using AzResourceDetailsDownloader.Capture;
using AzResourceDetailsDownloader.Cli;
using AzResourceDetailsDownloader.Config;
using AzResourceDetailsDownloader.Options;
using AzResourceDetailsDownloader.Orchestration;
using AzResourceDetailsDownloader.Output;
using AzResourceDetailsDownloader.Provisioning;
using AzResourceDetailsDownloader.Reporting;
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
    Console.Error.WriteLine("Usage: [--dry-run | --login | --run] [--only <armType>[,<armType>...]] [--max-cost-tier Free|Low|Medium|High]");
    return 1;
}

var repoRoot = RepoPaths.ResolveRepoRoot();

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

var maxCostTier = Enum.Parse<CostTier>(parsedArgs.MaxCostTierOverride ?? options.MaxCostTier, ignoreCase: true);

var filtered = catalog.ResourceTypes
    .Where(def => def.CostTier <= maxCostTier)
    .Where(def => parsedArgs.OnlyArmTypes is null || parsedArgs.OnlyArmTypes.Contains(def.ArmType))
    .ToList();

Console.WriteLine($"Catalog: {catalogPath} (schema v{catalog.SchemaVersion}, {catalog.ResourceTypes.Count} total entries)");
Console.WriteLine($"Max cost tier: {maxCostTier} — {filtered.Count} of {catalog.ResourceTypes.Count} entries selected");
Console.WriteLine();

if (parsedArgs.Mode == RunMode.DryRun)
{
    foreach (var def in filtered)
    {
        PrintPlannedUnit(def, options.DefaultLocation);
    }

    return 0;
}

// RunMode.Run: real Azure provisioning against the caller's already-logged-in `az` session.
var tenantId = options.TenantId;
var subscriptionId = options.SubscriptionId;
if (tenantId is null || subscriptionId is null)
{
    logger.LogInformation("TenantId/SubscriptionId not set in appsettings — resolving from 'az account show'...");
    var account = await AzCliContext.ResolveAsync();
    tenantId ??= account.TenantId;
    subscriptionId ??= account.SubscriptionId;
    logger.LogInformation("Using tenant {TenantId}, subscription {SubscriptionId}", tenantId, subscriptionId);
}

secrets["subscriptionId"] = subscriptionId;
secrets["tenantId"] = tenantId;

var credential = new AzureCliCredential();
var armClient = new ArmClient(credential, subscriptionId);
using var rawArmClient = new RawArmClient(credential);
await using var portalCapture = await PortalCaptureService.CreateAsync(
    options.PortalBaseUrl, tenantId, storageStatePath, logger);

var outputRoot = RepoPaths.Resolve(repoRoot, options.OutputRoot);
var pipeline = new ResourceTypePipeline(
    armClient, rawArmClient, subscriptionId, options.DefaultLocation, outputRoot, portalCapture, secrets, logger);

var summary = new RunSummary();
foreach (var def in filtered)
{
    var result = await pipeline.RunAsync(def);
    summary.Add(result);
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

static void PrintPlannedUnit(ResourceTypeDefinition def, string defaultLocation)
{
    var random = new Random();
    var resolvedPrereqs = new Dictionary<string, ProvisionedResourceRef>(StringComparer.OrdinalIgnoreCase);

    Console.WriteLine($"[{def.CostTier}] {def.ArmType} (api {def.ApiVersion})");
    Console.WriteLine($"  location: {def.Location ?? defaultLocation}");
    if (def.SlowProvisioning || def.EstimatedProvisionMinutes is not null)
    {
        Console.WriteLine($"  slow-provisioning: ~{def.EstimatedProvisionMinutes?.ToString() ?? "?"} min");
    }

    foreach (var prereq in def.Prerequisites)
    {
        var charset = prereq.NameRules?.Charset ?? "lowerAlnum";
        var nameWithPrereqsResolvedPreview = TemplateTokenResolver.ResolvePrereqTokens(prereq.NameTemplate, resolvedPrereqs);
        var previewName = TemplateTokenResolver.ResolveRandomTokens(nameWithPrereqsResolvedPreview, charset, random);
        resolvedPrereqs[prereq.Alias] = new ProvisionedResourceRef($"<resolved-id-of-{prereq.Alias}>", previewName);
        Console.WriteLine($"  prereq '{prereq.Alias}': {prereq.ArmType} -> name preview '{previewName}'");
    }

    var nameWithPrereqsResolved = TemplateTokenResolver.ResolvePrereqTokens(def.NameTemplate, resolvedPrereqs);
    var namePreview = TemplateTokenResolver.ResolveRandomTokens(
        nameWithPrereqsResolved, def.NameRules?.Charset ?? "lowerAlnum", random);
    Console.WriteLine($"  target name preview: '{namePreview}'");
    Console.WriteLine($"  output folder: output/{ArmTypeKey.From(def.ArmType)}/");
    Console.WriteLine();
}
