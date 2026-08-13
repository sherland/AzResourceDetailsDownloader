using System.Text.Json;
using AzResourceDetailsDownloader.Options;

namespace AzResourceDetailsDownloader.Tests;

// Cross-checks every committed output/{category}/{armType}/portal-fields.json against its sibling
// data.json — every Essentials field the portal showed should be traceable back to the real ARM
// JSON captured for the same resource. Catches a transcription mistake or a future
// EssentialsExtractor regression that starts inventing/misreading values.
//
// Deliberately does NOT check portal-fields.inferred.json — by design (see AGENT.md) those are
// hand-transcribed from a third-party source for a resource type that was never actually
// captured on this subscription, so there is no matching data.json to check them against; the
// file's existence (and its sibling .sources.md) is what makes them honest, not this test.
public class PortalFieldsConsistencyTests
{
    // Live-run against all 88 real portal-fields.json files committed at the time this test was
    // written (2026-08-13) surfaced ~85 distinct labels whose displayed value is never going to be
    // a literal substring of the raw ARM JSON, for reasons that are structural, not bugs. Grouped
    // by why, not alphabetically — if a *new* label shows up here later, investigate which bucket
    // it actually belongs to (or whether it's a real EssentialsExtractor/redaction bug) rather than
    // reflexively appending it.
    private static readonly HashSet<string> NonTraceableLabels = new(StringComparer.OrdinalIgnoreCase)
    {
        // Tenant/subscription display identity — never part of a resource's own ARM body, and/or
        // deliberately redacted to a fixed placeholder by OutputNormalizer (so by construction
        // can never equal whatever the real captured data.json happens to contain).
        "Subscription", "Directory Name", "Directory ID", "Microsoft Entra admin", "SQL Microsoft Entra admin",

        // Human-formatted timestamps — the portal renders a locale/timezone-formatted string
        // ("Thursday, August 13, 2026 at 14:50:31 GMT+2"); data.json has the same instant as a
        // plain ISO-8601 string. Same underlying value, unrecognizably different text.
        "Created", "Updated", "Created on", "Creation date", "Creation Time", "Modified Time",
        "Time created", "Last modified", "Last Updated Date", "Maintenance schedule",

        // Boolean/enum ARM values the portal renders as a friendlier English phrase instead of the
        // raw "true"/"false"/enum token (e.g. Redis's real provisioningState "Succeeded" displays
        // as "Running" once the cache is actually serving traffic).
        "Status", "Managed", "Zone redundant", "Partitioning", "Duplicate detection", "Sessions",
        "Forward messages to", "Dead lettering", "Support ordering", "Branch-to-branch",
        "Automatic failover enabled", "Enable No Public IP", "High availability", "Virtual endpoint",
        "Non-TLS access", "Autoscale", "Availability zones", "Availability zone",
        "Public network access", "Managed virtual network", "Auto-inflate throughput units",

        // Composite/derived display strings the portal assembles from several raw properties (or a
        // portal-side lookup table, e.g. a SKU-to-quota mapping) into one human sentence — no single
        // data.json field contains the same combined text.
        "Operating system", "Size", "Configuration", "Workspace type", "Pricing Tier",
        "Pricing tier", "Pricing Tier (SKU)", "SKU", "Public IP address", "Virtual network/subnet",
        "NAT subnet", "NAT IPs", "Virtual network & IP Address", "Maintenance scope",
        "Server name", "Elastic databases", "Elastic database settings", "Custom security rules",
        "Associated with", "Associations", "Communities filtered", "Circuits associated",
        "Throughput Units", "Daily message limit", "VUH usage (current month)", "Platform size",
        "Deployment Scope", "Colocation status", "Maintenance events", "Reboot setting",
        "Operational issues", "Private IP Ranges", "TLS inspection (Premium)",
        "IDPS mode (Premium)", "Paired recovery region", "Domain name label scope",
        "Service/UI Version", "Type", "Provisioning state",

        // Portal-only chrome: navigation links, action prompts, and "click to configure" placeholders
        // that were never resource data in the first place.
        "OTLP connection info", "Getting started", "ADR namespace", "Management services",
        "Networking", "Manage keys", "Topology", "Troubleshooting Guide", "FAQs",
        "Connection strings", "Keys", "Best practices", "New features",

        // Values sourced from a different API surface than the main resource GET this tool captures
        // (a separate keys/connection-string endpoint, or a portal-computed URL/endpoint not stored
        // verbatim on the resource) — genuinely real data, just not present in data.json by design.
        "Endpoint", "URL", "Account URI", "Queue URL", "Topic URL", "Instrumentation key",
        "Connection string", "Logs workspace", "Metrics ingestion endpoint", "Origin response timeout",
        "Public key", "Ports", "Location",
    };

    public static IEnumerable<object[]> PortalFieldsFiles()
    {
        var repoRoot = RepoPaths.ResolveRepoRoot();
        var outputRoot = Path.Combine(repoRoot, "output");
        if (!Directory.Exists(outputRoot))
        {
            yield break;
        }

        // Exact filename match — "portal-fields.json" only, never "portal-fields.inferred.json"
        // (see class comment for why the inferred variant is out of scope for this test).
        foreach (var path in Directory.EnumerateFiles(outputRoot, "portal-fields.json", SearchOption.AllDirectories))
        {
            yield return [path];
        }
    }

    [Theory]
    [MemberData(nameof(PortalFieldsFiles))]
    public void EveryField_IsTraceableToTheSiblingDataJson(string portalFieldsPath)
    {
        var dataJsonPath = Path.Combine(Path.GetDirectoryName(portalFieldsPath)!, "data.json");
        Assert.True(File.Exists(dataJsonPath),
            $"{portalFieldsPath} has no sibling data.json — portal-fields.json should only exist alongside a real capture.");

        var fields = JsonSerializer.Deserialize<List<PortalFieldRecord>>(File.ReadAllText(portalFieldsPath))
            ?? throw new InvalidOperationException($"{portalFieldsPath} did not deserialize to a field list.");
        var normalizedDataJson = Normalize(File.ReadAllText(dataJsonPath));

        var untraceable = fields
            .Where(f => !NonTraceableLabels.Contains(f.Label))
            .Where(f => Normalize(f.Value).Length > 0)
            .Where(f => !normalizedDataJson.Contains(Normalize(f.Value)))
            .Select(f => $"{f.Label} = \"{f.Value}\"")
            .ToList();

        Assert.True(untraceable.Count == 0,
            $"{portalFieldsPath}: field(s) not found anywhere in the sibling data.json " +
            $"(compared case/punctuation-insensitively): {string.Join("; ", untraceable)}");
    }

    // Lowercase + keep only letters/digits, so display formatting differences between the portal
    // (e.g. "West Europe") and the raw ARM JSON (e.g. "westeurope") don't cause false failures.
    private static string Normalize(string s) =>
        new string(s.Where(char.IsLetterOrDigit).ToArray()).ToLowerInvariant();

    private sealed record PortalFieldRecord(string Label, string Value);
}
