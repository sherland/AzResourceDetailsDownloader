using System.Globalization;
using System.Text.Json;
using System.Text.RegularExpressions;
using AzResourceDetailsDownloader.Output;

namespace AzResourceDetailsDownloader.Templating;

// Shared classification knowledge about Azure Portal Essentials-panel labels — which ones are
// genuinely composite/derived, which are tenant identity (redacted), which are timestamps, and
// which are a direct rendering of one named boolean ARM property. Originally lived inline in
// PortalFieldsConsistencyTests.cs; moved here so both that test AND a future template/recipe
// generator consume the exact same knowledge instead of drifting copies of it.
//
// Live-run against all 88 real portal-fields.json files committed at the time this was written
// (2026-08-13) surfaced ~64 distinct labels whose displayed value is never going to be a literal
// substring of the raw ARM JSON, for reasons that are structural, not bugs. Grouped by why, not
// alphabetically — if a *new* label shows up later, investigate which bucket it actually belongs
// to (or whether it's a real EssentialsExtractor/redaction bug) rather than reflexively appending
// it.
public static class PortalFieldKnowledge
{
    public static readonly HashSet<string> NonTraceableLabels = new(StringComparer.OrdinalIgnoreCase)
    {
        // "Maintenance schedule" looks like a timestamp label but isn't one — its value ("lør. 14:00
        // UTC (8h) / tir. 16:00 UTC (8h)") is a recurring weekly window description, not a single
        // instant, so it can't be date-parsed the way TimestampLabels below are. The other, genuine
        // timestamp labels that used to live in this bucket are now actively checked instead — see
        // TimestampLabels and TimestampIsTraceable.
        "Maintenance schedule",

        // Boolean/enum ARM values the portal renders as a friendlier English phrase instead of the
        // raw "true"/"false"/enum token (e.g. Redis's real provisioningState "Succeeded" displays
        // as "Running" once the cache is actually serving traffic). "Status" and most of its
        // neighbors below stay here rather than in BooleanBackedLabels because each resource type
        // has its own status vocabulary (Active/Succeeded/Online/Running/Ready/...) assembled by a
        // portal-side lookup, not a single boolean — genuinely not mechanically checkable. The
        // handful that *are* a direct single-property rendering moved to BooleanBackedLabels
        // instead of living here.
        "Status", "Managed", "Forward messages to", "Dead lettering", "Automatic failover enabled",
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

        // Portal-only chrome (navigation links, action prompts, "click to configure" placeholders)
        // used to live here too, but EssentialsExtractor.ChromeLabels now filters those out at
        // capture time instead — a label that was never resource data shouldn't need a test-side
        // exemption at all. If a *new* chrome label shows up in a future capture, add it there, not
        // here.

        // Values sourced from a different API surface than the main resource GET this tool captures
        // (a separate keys/connection-string endpoint, or a portal-computed URL/endpoint not stored
        // verbatim on the resource) — genuinely real data, just not present in data.json by design.
        "Endpoint", "URL", "Account URI", "Queue URL", "Topic URL", "Instrumentation key",
        "Connection string", "Logs workspace", "Metrics ingestion endpoint", "Origin response timeout",
        "Public key", "Ports", "Location",
    };

    // A short, human reason per NonTraceableLabels entry — not needed by the consistency test
    // (which only needs membership), but a future recipe generator can surface these instead of
    // just "unresolved" with no explanation. Deliberately not exhaustive: a label absent here still
    // gets a generic fallback message.
    public static readonly Dictionary<string, string> UnresolvedLabelHints = new(StringComparer.OrdinalIgnoreCase)
    {
        ["Status"] = "vocabulary — per-armType status text via a portal-side lookup, not a fixed mapping",
        ["Managed"] = "single enum (e.g. sku.name), not a plain bool — needs a bespoke 1-value mapping",
        ["Automatic failover enabled"] = "no backing property found in prior corpus inspection",
        ["Managed virtual network"] = "no backing property found in prior corpus inspection",
        ["Availability zones"] = "no backing property found in prior corpus inspection",
        ["Forward messages to"] = "property absent-when-disabled pattern, not a plain value",
        ["Dead lettering"] = "composite of 2 booleans combined into one sentence",
        ["Public network access"] = "composite of publicNetworkAccess + networkAcls.defaultAction",
        ["Auto-inflate throughput units"] = "composite of isAutoInflateEnabled + sku.tier",
        ["Non-TLS access"] = "single enum (clientProtocol), not a plain bool",
        ["Domain name label scope"] = "different API surface / portal-computed, not in this GET's body",
    };

    // Tenant/subscription display identity — never part of a resource's own ARM body; instead
    // OutputNormalizer redacts it to a fixed placeholder (see OutputNormalizer.Normalize and
    // .NormalizePortalFields). Rather than exempt these labels outright, assert the redaction
    // actually happened — a label that's supposed to be scrubbed but isn't is exactly the kind of
    // regression this test exists to catch. "Not configured" is a legitimate, non-identifying
    // portal state (no Entra admin assigned) distinct from a redacted real one, so it's allowed
    // alongside the placeholder rather than treated as a miss.
    public static readonly Dictionary<string, string[]> TenantIdentityAllowedValues =
        new(StringComparer.OrdinalIgnoreCase)
        {
            ["Subscription"] = [OutputNormalizer.PlaceholderSubscriptionName],
            // Never explicitly classified before this file existed — it only ever passed the old
            // consistency test by accident, since the placeholder GUID also appears verbatim inside
            // every capture's "id" field, so a whole-file substring search always found *something*.
            // Same blind spot as the Soft-delete/publicNetworkAccess false-positive that motivated
            // the dual-signal resolver in the first place — caught here by actually running the
            // resolver against the full corpus rather than assuming the old table was complete.
            ["Subscription ID"] = [OutputNormalizer.PlaceholderSubscriptionId],
            ["Directory Name"] = [OutputNormalizer.PlaceholderDirectoryName],
            ["Directory ID"] = [OutputNormalizer.PlaceholderTenantId],
            ["Microsoft Entra admin"] = [OutputNormalizer.PlaceholderEntraAdmin, "Not configured"],
            ["SQL Microsoft Entra admin"] = [OutputNormalizer.PlaceholderEntraAdmin, "Not configured"],
        };

    // Human-formatted timestamps — the portal renders a locale/timezone-formatted string
    // ("Thursday, August 13, 2026 at 14:50:31 GMT+2", "8/13/2026, 12:46 PM UTC",
    // "2026-08-13 13:14:05 (UTC)", or occasionally the browser's local time with no offset marker
    // at all); data.json has the same instant as a plain ISO-8601 string. Same underlying value,
    // unrecognizably different text — so parse both as instants and compare those instead of text.
    public static readonly HashSet<string> TimestampLabels = new(StringComparer.OrdinalIgnoreCase)
    {
        "Created", "Updated", "Created on", "Creation date", "Creation Time", "Modified Time",
        "Time created", "Last modified", "Last Updated Date",
    };

    // Boolean/enum ARM values the portal renders as a friendlier English phrase instead of the raw
    // "true"/"false" token — but only for labels individually confirmed (2026-08-13, against the
    // committed corpus) to be a direct rendering of one named property with no further composition.
    // Everything else that fits the general shape (e.g. "Status") stays in NonTraceableLabels
    // instead of being force-fit into this, since it's actually a per-resource-type vocabulary or
    // multi-property composite, not a single boolean.
    public static readonly Dictionary<string, string> BooleanBackedLabels =
        new(StringComparer.OrdinalIgnoreCase)
        {
            ["Zone redundant"] = "zoneRedundant",
            ["Partitioning"] = "enablePartitioning",
            ["Duplicate detection"] = "requiresDuplicateDetection",
            ["Sessions"] = "requiresSession",
            ["Support ordering"] = "supportOrdering",
            ["Branch-to-branch"] = "allowBranchToBranchTraffic",
            ["Enable No Public IP"] = "enableNoPublicIp",
            ["High availability"] = "highAvailability",
            ["Virtual endpoint"] = "highAvailability",
        };

    public static readonly Dictionary<string, bool> FriendlyBoolWords =
        new(StringComparer.OrdinalIgnoreCase)
        {
            ["Yes"] = true,
            ["No"] = false,
            ["Enabled"] = true,
            ["Disabled"] = false,
            ["Not enabled"] = false,
        };

    // Lowercase + keep only letters/digits, so display formatting differences between the portal
    // (e.g. "West Europe") and the raw ARM JSON (e.g. "westeurope") don't cause false failures.
    public static string Normalize(string s) =>
        new string(s.Where(char.IsLetterOrDigit).ToArray()).ToLowerInvariant();

    // ─────────────────────────────────────────────────────────────────────────
    // Timestamp matching
    // ─────────────────────────────────────────────────────────────────────────

    private static readonly Regex WeekdayPrefix = new(@"^\p{L}+,\s*", RegexOptions.Compiled);
    private static readonly Regex TrailingParenUtc = new(@"\s*\(UTC\)\s*$", RegexOptions.Compiled);
    private static readonly Regex TrailingBareUtc = new(@"\s*\bUTC\b\s*$", RegexOptions.Compiled);
    private static readonly Regex TrailingGmtOffset = new(@"\s*GMT([+-])(\d{1,2})\s*$", RegexOptions.Compiled);
    private static readonly Regex AlreadyHasNumericOffset = new(@"(Z|[+-]\d{2}:\d{2})$", RegexOptions.Compiled);
    private static readonly Regex CollapseWhitespace = new(@"\s+", RegexOptions.Compiled);
    // Anchored to the whole leaf value (not a substring search over raw text) — each candidate here
    // is one JSON string leaf's entire value, so a full-string match is both simpler and more
    // precise than scanning a giant text blob for date-shaped substrings.
    private static readonly Regex IsoInstantShape = new(
        @"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:\d{2})?$", RegexOptions.Compiled);

    public static bool TimestampIsTraceable(string portalValue, JsonElement root) =>
        FindTimestampMatchingPaths(portalValue, root).Count > 0;

    // Normalizes the portal's handful of known timestamp shapes down to something DateTimeOffset can
    // parse, then compares the resulting instant against every ISO-8601 string leaf found anywhere
    // in the document (rather than one specific property — different resource types stamp the
    // creation instant under different property names). Returns every leaf's ScribanPath that
    // matches within a 60-second tolerance (which absorbs the portal sometimes truncating to whole
    // seconds or even whole minutes, e.g. VMs' "Time created" drops seconds entirely), so a caller
    // that just wants yes/no can check Count > 0, and a caller that wants the actual source
    // property (the recipe resolver) gets every candidate, ranked by nothing in particular — name
    // similarity against the label is the caller's job.
    public static IReadOnlyList<string> FindTimestampMatchingPaths(string portalValue, JsonElement root)
    {
        var candidates = JsonTree.Flatten(root)
            .Where(l => l.Value.ValueKind == JsonValueKind.String)
            .Select(l => (l.ScribanPath, Text: l.Value.GetString() ?? ""))
            .Where(l => IsoInstantShape.IsMatch(l.Text))
            .Select(l => (l.ScribanPath, Parsed: TryParseIso(l.Text)))
            .Where(l => l.Parsed is not null)
            .Select(l => (l.ScribanPath, Instant: l.Parsed!.Value))
            .ToList();
        if (candidates.Count == 0)
        {
            return [];
        }

        var cleaned = WeekdayPrefix.Replace(portalValue, "").Replace(" at ", " ");
        var hasExplicitOffset = true;

        if (TrailingParenUtc.IsMatch(cleaned))
        {
            cleaned = TrailingParenUtc.Replace(cleaned, " +00:00");
        }
        else if (TrailingGmtOffset.IsMatch(cleaned))
        {
            cleaned = TrailingGmtOffset.Replace(cleaned,
                m => $" {m.Groups[1].Value}{int.Parse(m.Groups[2].Value, CultureInfo.InvariantCulture):00}:00");
        }
        else if (TrailingBareUtc.IsMatch(cleaned))
        {
            cleaned = TrailingBareUtc.Replace(cleaned, " +00:00");
        }
        else if (!AlreadyHasNumericOffset.IsMatch(cleaned))
        {
            hasExplicitOffset = false;
        }

        cleaned = CollapseWhitespace.Replace(cleaned, " ").Trim();

        if (!cleaned.Contains(':'))
        {
            // Date-only rendering (e.g. Service Bus subscriptions' "Created": "Thursday, August 13,
            // 2026", no time-of-day at all) — compare calendar dates instead of instants. The ±1 day
            // allowance absorbs the portal showing the date in local time while data.json's instant
            // is UTC, which can roll over across a day boundary near midnight.
            if (!DateTime.TryParse(cleaned, CultureInfo.InvariantCulture, DateTimeStyles.None, out var naiveDate))
            {
                return [];
            }
            return candidates
                .Where(c => Math.Abs((c.Instant.UtcDateTime.Date - naiveDate.Date).TotalDays) <= 1)
                .Select(c => c.ScribanPath)
                .ToList();
        }

        if (hasExplicitOffset)
        {
            if (!DateTimeOffset.TryParse(cleaned, CultureInfo.InvariantCulture, DateTimeStyles.None, out var portalInstant))
            {
                return [];
            }
            return candidates
                .Where(c => Math.Abs((c.Instant - portalInstant).TotalSeconds) < 60)
                .Select(c => c.ScribanPath)
                .ToList();
        }

        // No offset marker at all (e.g. "Modified Time": "8/13/2026, 2:57 PM") — the portal is
        // showing the browser's local wall-clock time without saying which zone. Rather than
        // hardcode the capture machine's timezone, brute-force every plausible UTC offset (half-hour
        // steps, -12..+14) and accept a match against any candidate instant.
        if (!DateTime.TryParse(cleaned, CultureInfo.InvariantCulture, DateTimeStyles.None, out var naive))
        {
            return [];
        }

        var matches = new List<string>();
        for (var offsetMinutes = -12 * 60; offsetMinutes <= 14 * 60; offsetMinutes += 30)
        {
            var offset = TimeSpan.FromMinutes(offsetMinutes);
            matches.AddRange(candidates
                .Where(c => Math.Abs((c.Instant.ToOffset(offset).DateTime - naive).TotalSeconds) < 60)
                .Select(c => c.ScribanPath));
        }
        return matches.Distinct().ToList();
    }

    private static DateTimeOffset? TryParseIso(string s) =>
        DateTimeOffset.TryParse(s, CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal, out var dto)
            ? dto
            : null;

    // ─────────────────────────────────────────────────────────────────────────
    // Boolean-backed matching
    // ─────────────────────────────────────────────────────────────────────────

    public static bool BooleanBackedFieldMatches(string label, string friendlyValue, JsonElement root) =>
        FindBooleanBackedPath(label, friendlyValue, root) is not null;

    // Looks up BooleanBackedLabels[label]'s raw property name anywhere in the document — as a path
    // segment, not just the leaf's own name, so a nested shape like Databricks' template-parameters
    // convention ("enableNoPublicIp": { "type": "Bool", "value": true }) still resolves via the
    // "value" leaf underneath it — and checks the first matching leaf's boolean (true/false, or the
    // string "Enabled"/"Disabled") against the friendly word's expected value.
    public static string? FindBooleanBackedPath(string label, string friendlyValue, JsonElement root)
    {
        if (!BooleanBackedLabels.TryGetValue(label, out var propertyName)
            || !FriendlyBoolWords.TryGetValue(friendlyValue, out var expectedBool))
        {
            return null;
        }

        foreach (var leaf in JsonTree.Flatten(root))
        {
            var segments = leaf.OriginalPath.Split(['.', '[', ']'], StringSplitOptions.RemoveEmptyEntries);
            if (!segments.Any(s => s.Equals(propertyName, StringComparison.OrdinalIgnoreCase)))
            {
                continue;
            }

            bool? actual = leaf.Value.ValueKind switch
            {
                JsonValueKind.True => true,
                JsonValueKind.False => false,
                JsonValueKind.String when leaf.Value.GetString() == "Enabled" => true,
                JsonValueKind.String when leaf.Value.GetString() == "Disabled" => false,
                _ => null,
            };

            if (actual == expectedBool)
            {
                return leaf.ScribanPath;
            }
        }

        return null;
    }
}
