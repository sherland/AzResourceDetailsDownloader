using System.Diagnostics;
using System.Text.Json;
using AzResourceDetailsDownloader.Capture;
using AzResourceDetailsDownloader.Config;
using AzResourceDetailsDownloader.Logging;
using AzResourceDetailsDownloader.Output;
using AzResourceDetailsDownloader.Provisioning;
using AzResourceDetailsDownloader.Reporting;
using Azure.ResourceManager;
using Microsoft.Extensions.Logging;

namespace AzResourceDetailsDownloader.Orchestration;

public sealed class ResourceTypePipeline(
    ArmClient armClient,
    RawArmClient rawArmClient,
    string subscriptionId,
    string defaultLocation,
    string outputRoot,
    PortalCaptureService portalCapture,
    IacExportService iacExport,
    CategoryResolver categoryResolver,
    IReadOnlyDictionary<string, string> secrets,
    int defaultProvisioningTimeoutMinutes,
    int provisioningTimeoutHeadroomMinutes,
    ILogger logger,
    string namePrefix = "")
{
    public async Task<RunResult> RunAsync(ResourceTypeDefinition def, CancellationToken ct = default)
    {
        var stopwatch = Stopwatch.StartNew();
        var rgName = $"rg-ardl-{Guid.NewGuid():N}"[..24];
        // The ephemeral resource group itself must always live in a real region — Azure Policy in some tenants
        // disallows resource groups in "global", even though individual resources (Action Groups, Private DNS
        // Zones, etc.) legitimately report "global" as their own location.
        var rgLocation = defaultLocation;
        // Seeded deterministically from the target's armType — see DeterministicNaming — so the same
        // catalog entry produces the same resolved names every run, keeping committed output files
        // (data.json, bicep/tf, and the resource name visible in portal.png) diff-stable across re-runs.
        var random = DeterministicNaming.CreateSeededRandom(def.ArmType, namePrefix);
        // Units run concurrently (see Program.cs's Parallel.ForEachAsync), so log lines from different units
        // interleave on the shared console — prefix every line from this unit with its ArmType to keep them
        // distinguishable, without needing to touch every LogInformation call site individually.
        var unitLogger = new PrefixedLogger(logger, $"[{def.ArmType}] ");

        unitLogger.LogInformation("Provisioning unit for '{ArmType}' in ephemeral resource group '{RgName}'", def.ArmType, rgName);

        var tags = new Dictionary<string, string>
        {
            ["purpose"] = "az-resource-details-downloader",
            ["armType"] = def.ArmType,
            ["createdUtc"] = DateTime.UtcNow.ToString("O")
        };

        try
        {
            await using var scope = await EphemeralResourceGroupScope.CreateAsync(
                armClient, subscriptionId, rgName, rgLocation, tags, unitLogger, ct);

            var provisioner = new ArmResourceProvisioner(rawArmClient);
            var resolvedPrereqs = new Dictionary<string, ProvisionedResourceRef>(StringComparer.OrdinalIgnoreCase);

            foreach (var prereq in def.Prerequisites)
            {
                var charset = prereq.NameRules?.Charset ?? "lowerAlnum";
                // A prerequisite whose own armType is exempt from deterministic naming (currently just
                // Microsoft.KeyVault/vaults) needs its own genuinely-random source here — the shared `random`
                // above is seeded from the *unit's target* armType, which only covers the case where the
                // target itself is the exempt type, not where it merely appears as a prerequisite.
                var prereqRandom = DeterministicNaming.IsExemptFromDeterminism(prereq.ArmType) ? new Random() : random;
                // Each prerequisite gets its own location independent of the target's — a target that is
                // itself "global" (e.g. a Metric Alert or a Private DNS Zone Link) must not force "global"
                // onto a prerequisite (e.g. a Storage Account or VNet) that doesn't support it. A prerequisite
                // may also reference an earlier prerequisite's *actual* location via `{prereq.alias.location}`
                // for cases where two resources must land in the same region as each other.
                var prereqLocation = TemplateTokenResolver.ResolvePrereqTokens(prereq.Location ?? defaultLocation, resolvedPrereqs);
                var prereqNameWithPrereqsResolved = TemplateTokenResolver.ResolvePrereqTokens(prereq.NameTemplate, resolvedPrereqs);
                var body = TemplateTokenResolver.ResolveAllTokens(prereq.RequestBody, resolvedPrereqs, secrets, charset, prereqRandom);

                var reference = await ProvisionWithLocationFallbackAsync(
                    provisioner, rgName, prereq.ArmType, prereq.ApiVersion, prereqNameWithPrereqsResolved, charset,
                    prereqRandom, prereqLocation, prereq.LocationFallbacks, body,
                    ProvisioningTimeoutFor(prereq.EstimatedProvisionMinutes), $"prerequisite '{prereq.Alias}'", unitLogger, ct);

                resolvedPrereqs[prereq.Alias] = reference;
            }

            var targetCharset = def.NameRules?.Charset ?? "lowerAlnum";
            var nameWithPrereqsResolved = TemplateTokenResolver.ResolvePrereqTokens(def.NameTemplate, resolvedPrereqs);
            var targetBody = TemplateTokenResolver.ResolveAllTokens(def.RequestBody, resolvedPrereqs, secrets, targetCharset, random);
            // Same `{prereq.alias.location}` support as prerequisites — needed for a target that must land in
            // whatever region its prerequisite actually did (e.g. a Container App must share its Managed
            // Environment's region; if the environment's own location-fallback kicked in, the target has to
            // follow it there, not independently resolve to the default location).
            var targetLocation = TemplateTokenResolver.ResolvePrereqTokens(def.Location ?? defaultLocation, resolvedPrereqs);

            var targetRef = await ProvisionWithLocationFallbackAsync(
                provisioner, rgName, def.ArmType, def.ApiVersion, nameWithPrereqsResolved, targetCharset,
                random, targetLocation, def.LocationFallbacks, targetBody,
                ProvisioningTimeoutFor(def.EstimatedProvisionMinutes), "target", unitLogger, ct);
            var targetName = targetRef.Name;

            using var rawJson = await rawArmClient.GetRawAsync(targetRef.Id, def.ApiVersion, ct);

            unitLogger.LogInformation("  capturing portal screenshot for '{Name}'", targetName);
            var capture = await portalCapture.CaptureAsync(targetRef.Id, targetName, unitLogger, ct);

            // Exported at resource-group scope (not per-resource) so the target and its prerequisites — all
            // provisioned into this one ephemeral group — come back together with cross-references resolved,
            // matching the JSON/screenshot capture's existing per-unit granularity. Best-effort: a failure
            // here is logged and skipped, not fatal to the unit, since the ARM JSON capture is the core
            // artifact and IaC exports are a supplementary convenience.
            unitLogger.LogInformation("  exporting bicep/terraform for resource group '{RgName}'", rgName);
            var bicep = await iacExport.TryExportBicepAsync(rgName, unitLogger, ct);
            var terraform = await iacExport.TryExportTerraformAsync(subscriptionId, rgName, unitLogger, ct);

            var category = categoryResolver.ResolveCategory(def.ArmType);
            await OutputWriter.WriteAsync(
                outputRoot, def.ArmType, category, rawJson, capture.Screenshot,
                subscriptionId, secrets["tenantId"], rgName,
                bicep, terraform, capture.Notices, capture.Fields, ct);

            unitLogger.LogInformation("  captured '{ArmType}' successfully in {Elapsed}", def.ArmType, stopwatch.Elapsed);
            return new RunResult(def.ArmType, true, stopwatch.Elapsed, null);
        }
        catch (Exception ex)
        {
            unitLogger.LogError(ex, "Failed to provision/capture '{ArmType}'", def.ArmType);
            return new RunResult(def.ArmType, false, stopwatch.Elapsed, ex.Message);
        }
    }

    // Tries `primaryLocation` first, then each of `locationFallbacks` in order, but only advances to the next
    // location on a *known capacity/availability* error (see CapacityErrorDetector) — any other failure
    // (bad request body, policy violation, quota) would fail identically everywhere, so it propagates
    // immediately instead of burning time retrying elsewhere. A fresh name is generated per attempt: live
    // testing confirmed ARM's `location` is immutable on an existing resource name (a same-name retry in a
    // different region 409s with InvalidResourceLocation), and that a failed resource can sit in a
    // ScheduledForDelete state for ~45-60s before actually clearing — reusing a new name sidesteps both,
    // and the abandoned same-named resource in the original region is cleaned up regardless by this unit's
    // own ephemeral-resource-group teardown.
    private async Task<ProvisionedResourceRef> ProvisionWithLocationFallbackAsync(
        ArmResourceProvisioner provisioner,
        string rgName,
        string armType,
        string apiVersion,
        string nameTemplateWithPrereqsResolved,
        string charset,
        Random random,
        string primaryLocation,
        IReadOnlyList<string>? locationFallbacks,
        JsonElement body,
        TimeSpan? timeout,
        string logLabel,
        ILogger unitLogger,
        CancellationToken ct)
    {
        var locations = new List<string> { primaryLocation };
        if (locationFallbacks is { Count: > 0 })
        {
            locations.AddRange(locationFallbacks);
        }

        for (var i = 0; i < locations.Count; i++)
        {
            var location = locations[i];
            var name = TemplateTokenResolver.ResolveRandomTokens(nameTemplateWithPrereqsResolved, charset, random);

            try
            {
                // Deterministic naming means a previous run's soft-deleted resource (Key Vault, Cognitive
                // Services, App Configuration, API Management) can still reserve this exact name — clear it
                // first so a second run of the same catalog entry doesn't fail. No-op for every other type.
                await SoftDeletePurger.PurgeIfSoftDeletedAsync(armType, name, location, unitLogger, ct);

                unitLogger.LogInformation(
                    "  provisioning {Label}: {ArmType} '{Name}' in '{Location}'", logLabel, armType, name, location);
                return await CreateWithRegistrationRetryAsync(
                    provisioner, armType, apiVersion, rgName, name, location, body, timeout, ct);
            }
            catch (InvalidOperationException ex) when (i < locations.Count - 1 && CapacityErrorDetector.IsCapacityError(ex.Message))
            {
                unitLogger.LogWarning(
                    "  {ArmType} hit a capacity error in '{Location}'; retrying in fallback location '{NextLocation}'.",
                    armType, location, locations[i + 1]);
            }

            async Task<ProvisionedResourceRef> CreateWithRegistrationRetryAsync(
                ArmResourceProvisioner p, string t, string v, string rg, string n, string loc, JsonElement b, TimeSpan? to, CancellationToken token)
            {
                try
                {
                    return await p.CreateOrUpdateAsync(subscriptionId, rg, t, v, n, loc, b, to, token);
                }
                catch (InvalidOperationException ex) when (ResourceProviderRegistrationErrorDetector.TryGetUnregisteredNamespace(ex.Message, out var ns))
                {
                    unitLogger.LogWarning(
                        "  {ArmType} needs resource provider '{Namespace}', which isn't registered on this subscription yet — registering it now (one-time, no-cost) and retrying.",
                        t, ns);
                    await rawArmClient.RegisterResourceProviderAsync(subscriptionId, ns, token);
                    return await p.CreateOrUpdateAsync(subscriptionId, rg, t, v, n, loc, b, to, token);
                }
            }
        }

        // Unreachable: the loop above either returns on success or lets the final location's exception
        // propagate uncaught (the `when` guard is false on the last iteration).
        throw new UnreachableException();
    }

    // Give slow-provisioning types (per config's estimatedProvisionMinutes) enough headroom beyond their
    // estimate — Redis Cache, for example, is documented at ~15-25 min but can occasionally run longer.
    // Both the headroom and the fallback for types without an estimate are configurable (Pipeline section
    // in appsettings.json) rather than hardcoded, so a slow/flaky resource type can be tuned without a rebuild.
    private TimeSpan ProvisioningTimeoutFor(int? estimatedProvisionMinutes) =>
        TimeSpan.FromMinutes(estimatedProvisionMinutes is { } minutes
            ? minutes + provisioningTimeoutHeadroomMinutes
            : defaultProvisioningTimeoutMinutes);
}
