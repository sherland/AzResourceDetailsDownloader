using System.Collections.Concurrent;
using AzResourceDetailsDownloader.Capture;
using AzResourceDetailsDownloader.Cli;
using AzResourceDetailsDownloader.Config;
using AzResourceDetailsDownloader.Options;
using AzResourceDetailsDownloader.Orchestration;
using AzResourceDetailsDownloader.Output;
using AzResourceDetailsDownloader.Provisioning;
using AzResourceDetailsDownloader.Reporting;
using AzResourceDetailsDownloader.Templating;
using Azure.Identity;
using Azure.ResourceManager;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

ParsedArgs parsedArgs;
try
{
    parsedArgs = ParsedArgs.Parse(args);
}
catch (ArgumentException ex)
{
    Console.Error.WriteLine(ex.Message);
    Console.Error.WriteLine(
        "Usage: [--dry-run | --login | --run | --generate-field-recipes | --generate-templates] [--only <armType>[,<armType>...]] [--max-cost-tier Free|Low|Medium|High|VeryHigh] [--max-concurrency <n>] [--live-ui]");
    return 1;
}

var repoRoot = RepoPaths.ResolveRepoRoot();

if (parsedArgs.Mode == RunMode.GenerateFieldRecipes)
{
    var recipeSourceRoot = Path.Combine(repoRoot, "output");
    var entries = PortalFieldRecipeCatalogGenerator.Generate(recipeSourceRoot);
    var catalogOutputPath = Path.Combine(repoRoot, "config", "portal-field-recipes.json");
    PortalFieldRecipeCatalogGenerator.WriteCatalog(entries, catalogOutputPath);
    Console.WriteLine($"Wrote {catalogOutputPath}");
    Console.WriteLine(PortalFieldRecipeCatalogGenerator.Summarize(entries));
    return 0;
}

if (parsedArgs.Mode == RunMode.GenerateTemplates)
{
    var templateSourceRoot = Path.Combine(repoRoot, "output");
    var templatesDir = Path.Combine(repoRoot, "templates");
    var results = TemplateBatchGenerator.GenerateAll(templateSourceRoot, templatesDir);
    foreach (var result in results)
    {
        Console.WriteLine($"{result.ArmType}: {result.TemplatePath} ({result.TodoRowCount} TODO row(s))");
    }
    var totalTodos = results.Sum(r => r.TodoRowCount);
    Console.WriteLine($"Generated {results.Count} templates, {totalTodos} TODO rows total across all of them.");
    return 0;
}

var configuration = new ConfigurationBuilder()
    .SetBasePath(AppContext.BaseDirectory)
    .AddJsonFile("appsettings.json", optional: false)
    .AddJsonFile("appsettings.Development.json", optional: true)
    .AddEnvironmentVariables(prefix: "ARDL_")
    .Build();

var secrets = configuration.GetSection("Secrets").Get<Dictionary<string, string>>()
    ?? new Dictionary<string, string>();

var options = configuration.GetSection("Pipeline").Get<PipelineOptions>()
    ?? throw new InvalidOperationException("Missing 'Pipeline' configuration section in appsettings.json.");

using var loggerFactory = LoggerFactory.Create(builder => builder.AddSimpleConsole(o =>
{
    o.SingleLine = true;
    o.TimestampFormat = "HH:mm:ss ";
}));
var logger = loggerFactory.CreateLogger("AzResourceDetailsDownloader");

var storageStatePath = RepoPaths.Resolve(repoRoot, options.StorageStatePath);

if (parsedArgs.Mode == RunMode.Login)
{
    await LoginBootstrap.RunAsync(options.PortalBaseUrl, storageStatePath, logger);
    return 0;
}

var catalogPath = RepoPaths.Resolve(repoRoot, options.CatalogPath);
var catalog = ResourceTypeCatalogLoader.Load(catalogPath);

var abbreviationsPath = RepoPaths.Resolve(repoRoot, options.AbbreviationsConfigPath);
var abbreviationsCatalog = ResourceAbbreviationsLoader.TryLoad(abbreviationsPath);
if (abbreviationsCatalog is null)
{
    logger.LogInformation(
        "No abbreviations config found at '{Path}' — every entry will fall into the '{Uncategorized}' output folder. Run fetch-resource-abbreviations.ps1 to populate it.",
        abbreviationsPath, CategoryResolver.Uncategorized);
}

var categoryOverridesPath = RepoPaths.Resolve(repoRoot, options.CategoryOverridesConfigPath);
var categoryOverridesCatalog = CategoryOverridesLoader.TryLoad(categoryOverridesPath);
var categoryResolver = new CategoryResolver(abbreviationsCatalog, categoryOverridesCatalog);

var maxCostTier = Enum.Parse<CostTier>(parsedArgs.MaxCostTierOverride ?? options.MaxCostTier, ignoreCase: true);

var filtered = catalog.ResourceTypes
    .Where(def => def.Cost.Tier <= maxCostTier)
    .Where(def => parsedArgs.OnlyArmTypes is null || parsedArgs.OnlyArmTypes.Contains(def.ArmType))
    .ToList();

Console.WriteLine($"Catalog: {catalogPath} (schema v{catalog.SchemaVersion}, {catalog.ResourceTypes.Count} total entries)");
Console.WriteLine($"Max cost tier: {maxCostTier} — {filtered.Count} of {catalog.ResourceTypes.Count} entries selected");
Console.WriteLine();

if (parsedArgs.Mode == RunMode.DryRun)
{
    foreach (var def in filtered)
    {
        PrintPlannedUnit(def, options.DefaultLocation, categoryResolver);
    }

    return 0;
}

// RunMode.Run: real Azure provisioning against the caller's already-logged-in `az` session.
var tenantId = options.TenantId;
var subscriptionId = options.SubscriptionId;
// Always resolved (not just when tenantId/subscriptionId are unset) — this is also the only way
// to learn the signed-in user's UPN, which ARM auto-stamps into every resource's systemData
// (createdBy/lastModifiedBy) and which needs the same redaction treatment as subscription/tenant
// ID. Live-observed leak (2026-08-13): the operator's real personal email address, uncaught
// because nothing upstream of OutputNormalizer ever knew what value to redact.
logger.LogInformation("Resolving account context from 'az account show'...");
var account = await AzCliContext.ResolveAsync();
tenantId ??= account.TenantId;
subscriptionId ??= account.SubscriptionId;
logger.LogInformation("Using tenant {TenantId}, subscription {SubscriptionId}", tenantId, subscriptionId);

secrets["subscriptionId"] = subscriptionId;
secrets["tenantId"] = tenantId;
if (account.UserPrincipalName is { Length: > 0 } upn)
{
    secrets["userPrincipalName"] = upn;
}

var credential = new AzureCliCredential();
var armClient = new ArmClient(credential, subscriptionId);
using var rawArmClient = new RawArmClient(credential);
using var iacExport = new IacExportService(credential, rawArmClient);
await using var portalCapture = await PortalCaptureService.CreateAsync(
    options.PortalBaseUrl, tenantId, storageStatePath);

var namePrefix = parsedArgs.NamePrefixOverride ?? options.NamePrefix ?? "";
if (namePrefix.Length > 0)
{
    logger.LogInformation("Using name prefix '{NamePrefix}' (shifts deterministic naming to dodge global-uniqueness collisions)", namePrefix);
}

var outputRoot = RepoPaths.Resolve(repoRoot, options.OutputRoot);

// --live-ui hands the terminal to a Spectre.Console Live display for the two loops below — every
// unit's own log lines (ResourceTypePipeline logs profusely: provisioning, capturing, exporting)
// would otherwise raw-write to the same console region Live is repainting and corrupt it. So the
// pipeline gets a different ILogger for this run: one that captures formatted lines into a ring
// buffer instead, which LiveWorkerUi renders into its own "Recent activity" panel — same debugging
// signal, just relocated for the duration of the live display. Auto-disabled when stdout isn't a
// real interactive terminal (e.g. piped to a file/CI), since Live's repainting assumes one.
var useLiveUi = parsedArgs.LiveUi && !Console.IsOutputRedirected;
var logRingBuffer = useLiveUi ? new LogRingBuffer() : null;
var pipelineLogger = useLiveUi
    ? new RingBufferLoggerProvider(logRingBuffer!).CreateLogger("AzResourceDetailsDownloader")
    : logger;

var pipeline = new ResourceTypePipeline(
    armClient, rawArmClient, subscriptionId, options.DefaultLocation, outputRoot, portalCapture, iacExport,
    categoryResolver, secrets, options.DefaultProvisioningTimeoutMinutes, options.ProvisioningTimeoutHeadroomMinutes,
    pipelineLogger, namePrefix);

var maxConcurrency = parsedArgs.MaxConcurrencyOverride ?? options.MaxConcurrentUnits;
logger.LogInformation("Running with max concurrency {MaxConcurrency}", maxConcurrency);

// Wraps one pipeline.RunAsync call, optionally claiming a "worker slot" from a small fixed-size pool
// purely for the live UI's benefit — Parallel.ForEachAsync itself exposes no stable worker identity,
// so this is how LiveWorkerUi gets one. Slot claim/release never changes the unit's own behavior,
// timing, or cancellation — a no-op when slotPool/board are null (--live-ui off).
async Task RunUnitAsync(
    ResourceTypeDefinition def, ConcurrentQueue<int>? slotPool, WorkerStatusBoard? board,
    Action<RunResult> record, CancellationToken ct)
{
    var slot = -1;
    if (slotPool is not null && board is not null && slotPool.TryDequeue(out var claimed))
    {
        slot = claimed;
        board.SetRunning(slot, def.ArmType);
    }

    try
    {
        var result = await pipeline.RunAsync(def, ct);
        record(result);
        if (slot >= 0)
        {
            board!.SetFinished(slot, result.Success);
        }
    }
    finally
    {
        if (slot >= 0)
        {
            slotPool!.Enqueue(slot);
        }
    }
}

// Units run concurrently — each does its own ARM provisioning/polling independently, while portal screenshot
// capture is serialized inside PortalCaptureService (one shared browser page/tab, kept single deliberately
// to avoid re-triggering MFA). RunSummary.Add is lock-guarded for concurrent writers.
var summary = new RunSummary();
var mainBoard = useLiveUi ? new WorkerStatusBoard(maxConcurrency, filtered.Count) : null;
var mainSlotPool = useLiveUi ? new ConcurrentQueue<int>(Enumerable.Range(0, maxConcurrency)) : null;
Func<Task> runMainPass = () => Parallel.ForEachAsync(
    filtered,
    new ParallelOptions { MaxDegreeOfParallelism = maxConcurrency },
    (def, ct) => new ValueTask(RunUnitAsync(def, mainSlotPool, mainBoard, summary.Add, ct)));

if (useLiveUi)
{
    await LiveWorkerUi.RunAsync(mainBoard!, logRingBuffer!, "Main run", runMainPass);
}
else
{
    await runMainPass();
}

// Quota exhaustion (see QuotaErrorDetector) is usually a symptom of running too many compute-heavy units
// at once, not a real per-unit failure — a quieter retry pass at lower concurrency often succeeds where the
// crowded main pass didn't, without needing the user to manually re-run --only for each one afterward.
var quotaFailedDefs = summary.Results
    .Where(r => !r.Success && QuotaErrorDetector.IsQuotaError(r.Error))
    .Select(r => filtered.First(d => d.ArmType == r.ArmType))
    .ToList();

if (quotaFailedDefs.Count > 0)
{
    var quotaRetryConcurrency = options.QuotaRetryConcurrency;
    logger.LogWarning(
        "{Count} unit(s) failed with a subscription-quota error; retrying at concurrency {RetryConcurrency}: {ArmTypes}",
        quotaFailedDefs.Count, quotaRetryConcurrency, string.Join(", ", quotaFailedDefs.Select(d => d.ArmType)));

    var retryBoard = useLiveUi ? new WorkerStatusBoard(quotaRetryConcurrency, quotaFailedDefs.Count) : null;
    var retrySlotPool = useLiveUi ? new ConcurrentQueue<int>(Enumerable.Range(0, quotaRetryConcurrency)) : null;
    Func<Task> runRetryPass = () => Parallel.ForEachAsync(
        quotaFailedDefs,
        new ParallelOptions { MaxDegreeOfParallelism = quotaRetryConcurrency },
        (def, ct) => new ValueTask(RunUnitAsync(def, retrySlotPool, retryBoard, summary.ReplaceOrAdd, ct)));

    if (useLiveUi)
    {
        await LiveWorkerUi.RunAsync(retryBoard!, logRingBuffer!, "Quota retry pass", runRetryPass);
    }
    else
    {
        await runRetryPass();
    }
}

await summary.WriteAsync(outputRoot);

Console.WriteLine();
Console.WriteLine("Summary:");
foreach (var result in summary.Results)
{
    var status = result.Success ? "OK  " : "FAIL";
    Console.WriteLine($"  [{status}] {result.ArmType} ({result.Elapsed.TotalSeconds:F1}s){(result.Error is null ? "" : $" — {result.Error}")}");
}

return summary.Results.Any(r => !r.Success) ? 1 : 0;

static void PrintPlannedUnit(ResourceTypeDefinition def, string defaultLocation, CategoryResolver categoryResolver)
{
    var random = new Random();
    var resolvedPrereqs = new Dictionary<string, ProvisionedResourceRef>(StringComparer.OrdinalIgnoreCase);

    Console.WriteLine($"[{def.Cost.Tier}] {def.ArmType} (api {def.ApiVersion})");
    if (def.Cost.PerHourAccumulated is { } perHourAccumulated)
    {
        Console.WriteLine($"  cost: ~${perHourAccumulated.ToString("F2", System.Globalization.CultureInfo.InvariantCulture)}/hour accumulated" +
            (def.Cost.PerHour == perHourAccumulated ? "" : $" (${def.Cost.PerHour?.ToString("F2", System.Globalization.CultureInfo.InvariantCulture)}/hour own)"));
    }
    if (def.SlowProvisioning || def.EstimatedProvisionMinutes is not null)
    {
        Console.WriteLine($"  slow-provisioning: ~{def.EstimatedProvisionMinutes?.ToString() ?? "?"} min");
    }

    foreach (var prereq in def.Prerequisites)
    {
        var charset = prereq.NameRules?.Charset ?? "lowerAlnum";
        var previewLocation = TemplateTokenResolver.ResolvePrereqTokens(prereq.Location ?? defaultLocation, resolvedPrereqs);
        var nameWithPrereqsResolvedPreview = TemplateTokenResolver.ResolvePrereqTokens(prereq.NameTemplate, resolvedPrereqs);
        var previewName = TemplateTokenResolver.ResolveRandomTokens(nameWithPrereqsResolvedPreview, charset, random);
        resolvedPrereqs[prereq.Alias] = new ProvisionedResourceRef($"<resolved-id-of-{prereq.Alias}>", previewName, previewLocation);
        var fallbackSuffix = prereq.LocationFallbacks is { Count: > 0 } f ? $" (fallbacks: {string.Join(", ", f)})" : "";
        Console.WriteLine($"  prereq '{prereq.Alias}': {prereq.ArmType} -> name preview '{previewName}', location '{previewLocation}'{fallbackSuffix}");
    }

    var targetLocationPreview = TemplateTokenResolver.ResolvePrereqTokens(def.Location ?? defaultLocation, resolvedPrereqs);
    var targetFallbackSuffix = def.LocationFallbacks is { Count: > 0 } tf ? $" (fallbacks: {string.Join(", ", tf)})" : "";
    Console.WriteLine($"  location: {targetLocationPreview}{targetFallbackSuffix}");

    var nameWithPrereqsResolved = TemplateTokenResolver.ResolvePrereqTokens(def.NameTemplate, resolvedPrereqs);
    var namePreview = TemplateTokenResolver.ResolveRandomTokens(
        nameWithPrereqsResolved, def.NameRules?.Charset ?? "lowerAlnum", random);
    Console.WriteLine($"  target name preview: '{namePreview}'");
    var category = categoryResolver.ResolveCategory(def.ArmType);
    Console.WriteLine($"  output folder: output/{CategoryKey.From(category)}/{ArmTypeKey.From(def.ArmType)}/");
    Console.WriteLine();
}
