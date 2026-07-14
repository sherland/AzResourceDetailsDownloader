using System.Diagnostics;
using AzResourceDetailsDownloader.Capture;
using AzResourceDetailsDownloader.Config;
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
    IReadOnlyDictionary<string, string> secrets,
    ILogger logger)
{
    public async Task<RunResult> RunAsync(ResourceTypeDefinition def, CancellationToken ct = default)
    {
        var stopwatch = Stopwatch.StartNew();
        var rgName = $"rg-ardl-{Guid.NewGuid():N}"[..24];
        // The ephemeral resource group itself must always live in a real region — Azure Policy in some tenants
        // disallows resource groups in "global", even though individual resources (Action Groups, Private DNS
        // Zones, etc.) legitimately report "global" as their own location.
        var rgLocation = defaultLocation;
        var resourceLocation = def.Location ?? defaultLocation;
        var random = new Random();

        logger.LogInformation("Provisioning unit for '{ArmType}' in ephemeral resource group '{RgName}'", def.ArmType, rgName);

        var tags = new Dictionary<string, string>
        {
            ["purpose"] = "az-resource-details-downloader",
            ["armType"] = def.ArmType,
            ["createdUtc"] = DateTime.UtcNow.ToString("O")
        };

        try
        {
            await using var scope = await EphemeralResourceGroupScope.CreateAsync(
                armClient, subscriptionId, rgName, rgLocation, tags, logger, ct);

            var provisioner = new ArmResourceProvisioner(rawArmClient);
            var resolvedPrereqs = new Dictionary<string, ProvisionedResourceRef>(StringComparer.OrdinalIgnoreCase);

            foreach (var prereq in def.Prerequisites)
            {
                var charset = prereq.NameRules?.Charset ?? "lowerAlnum";
                // Each prerequisite gets its own location independent of the target's — a target that is
                // itself "global" (e.g. a Metric Alert or a Private DNS Zone Link) must not force "global"
                // onto a prerequisite (e.g. a Storage Account or VNet) that doesn't support it.
                var prereqLocation = prereq.Location ?? defaultLocation;
                var prereqNameWithPrereqsResolved = TemplateTokenResolver.ResolvePrereqTokens(prereq.NameTemplate, resolvedPrereqs);
                var name = TemplateTokenResolver.ResolveRandomTokens(prereqNameWithPrereqsResolved, charset, random);
                var body = TemplateTokenResolver.ResolveAllTokens(prereq.RequestBody, resolvedPrereqs, secrets, charset, random);

                logger.LogInformation("  provisioning prerequisite '{Alias}': {ArmType} '{Name}'", prereq.Alias, prereq.ArmType, name);

                var reference = await provisioner.CreateOrUpdateAsync(
                    subscriptionId, rgName, prereq.ArmType, prereq.ApiVersion, name, prereqLocation, body,
                    ProvisioningTimeoutFor(prereq.EstimatedProvisionMinutes), ct);

                resolvedPrereqs[prereq.Alias] = reference;
            }

            var targetCharset = def.NameRules?.Charset ?? "lowerAlnum";
            var nameWithPrereqsResolved = TemplateTokenResolver.ResolvePrereqTokens(def.NameTemplate, resolvedPrereqs);
            var targetName = TemplateTokenResolver.ResolveRandomTokens(nameWithPrereqsResolved, targetCharset, random);
            var targetBody = TemplateTokenResolver.ResolveAllTokens(def.RequestBody, resolvedPrereqs, secrets, targetCharset, random);

            logger.LogInformation("  provisioning target: {ArmType} '{Name}'", def.ArmType, targetName);

            var targetRef = await provisioner.CreateOrUpdateAsync(
                subscriptionId, rgName, def.ArmType, def.ApiVersion, targetName, resourceLocation, targetBody,
                ProvisioningTimeoutFor(def.EstimatedProvisionMinutes), ct);

            using var rawJson = await rawArmClient.GetRawAsync(targetRef.Id, def.ApiVersion, ct);

            logger.LogInformation("  capturing portal screenshot for '{Name}'", targetName);
            var screenshot = await portalCapture.CaptureAsync(targetRef.Id, targetName, ct);

            await OutputWriter.WriteAsync(outputRoot, def.ArmType, rawJson, screenshot, ct);

            logger.LogInformation("  captured '{ArmType}' successfully in {Elapsed}", def.ArmType, stopwatch.Elapsed);
            return new RunResult(def.ArmType, true, stopwatch.Elapsed, null);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Failed to provision/capture '{ArmType}'", def.ArmType);
            return new RunResult(def.ArmType, false, stopwatch.Elapsed, ex.Message);
        }
    }

    // Give slow-provisioning types (per config's estimatedProvisionMinutes) enough headroom beyond their
    // estimate — Redis Cache, for example, is documented at ~15 min but can occasionally run longer.
    private static TimeSpan? ProvisioningTimeoutFor(int? estimatedProvisionMinutes) =>
        estimatedProvisionMinutes is { } minutes ? TimeSpan.FromMinutes(minutes + 10) : null;
}
