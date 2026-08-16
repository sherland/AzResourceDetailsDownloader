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

        // New portal-only UI surfaced by the 2026-08-14 Essentials-panel redesign (see
        // EssentialsExtractor's class comment) — neither has any backing property anywhere in a
        // Managed Identity's raw ARM body; portal-computed/feature-flagged, not resource data.
        "Isolation Scope", "Resource (Preview)",

        // Same "composite/derived display string" bucket as above, surfaced by the 2026-08-14
        // 60-type backfill batch once the sandbox-iframe and multi-layout EssentialsExtractor fixes
        // let these types' real Essentials fields through for the first time — not extractor bugs,
        // just fields no earlier capture had ever actually reached.
        "Storage type", "Encryption", "Snapshot access state", "Disk size", "Cluster tier",
        "Connectivity method", "Authentication", "Storage encryption", "Read region",
        "Total throughput limit", "Free Tier Discount", "Studio web URL", "Replicas",
        "Elastic pool", "Earliest restore point", "Platform Type", "Frontend IP address", "Scope",
        "Severity", "Soft delete", "Tier", "Server status", "Database status",
        "Accelerated networking", "Environment type", "Aspire Dashboard", "Network configuration",
        "Node pools", "DNS servers", "Subnets", "MQTT broker", "DNS Name", "MCP Endpoint",
        "SF Explorer", "Publisher :: Offer :: SKU", "Scope (In-tenant)", "Scope (Cross-tenant)",
        "Replication", "Account kind", "Definition", "Runs last 24 hours", "Workflow Type",
        "Geo-replication",

        // Look timestamp-shaped but aren't traceable — confirmed by grepping the sibling data.json
        // for any creation-adjacent field on each resource type and finding none; a portal-computed
        // or separate-API-surface value (same bucket as "Endpoint"/"URL" above), not a parsing gap.
        "Date created", "Created time",

        // "Name" is deliberately generic — accepted here because Portal/dashboards renders it as
        // "{resourceName} ({friendly title})", a composite no data.json field contains verbatim. A
        // resource type that ever needs "Name" to be a directly-traceable single value would
        // silently stop being checked too; worth revisiting if that turns out to matter more than
        // this one composite case.
        "Name",
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

        // The entries below are confirmed by reading the Azure Portal's own field-builder function
        // source live, via a React fiber walk (2026-08-14 pilot batch across 13 resource types — see
        // EssentialsExtractor.DumpFiberBuilderSourceAsync, opt-in via ARDL_DEBUG_ESSENTIALS_DIR, and
        // AGENT.md). Unlike everything above this line, these aren't inferred from failing to find a
        // value match — the raw property really is there; what defeats value-matching is a
        // friendly-text lookup table between the raw value and the rendered string (so the rendered
        // text never appears anywhere in data.json, no matter how the matcher is tuned). Encoding
        // those lookup tables as real FieldRecipe shortcuts would need a verified reference source
        // (the same "fetched, not guessed" bar as config/azure-locations.json) — only one enum value
        // per field was actually observed live, not enough to hardcode the rest with confidence.
        ["Storage type"] = "sku.name, via an untraced SKU-to-friendly-name lookup (same shape as " +
            "Storage Accounts' \"Replication\"/\"Account kind\", confirmed live on Compute/disks)",
        ["Cluster tier"] = "properties.compute.tier, via an untraced friendly-name lookup " +
            "(confirmed live on DocumentDB/mongoClusters)",
        ["Connectivity method"] = "properties.publicNetworkAccess (\"Enabled\"/\"Disabled\"), " +
            "rendered as \"Public access\"/\"Private access\" (confirmed live on DocumentDB/mongoClusters)",
        ["Authentication"] = "properties.authConfig.allowedModes (an array of enum strings), combined " +
            "into one sentence (confirmed live on DocumentDB/mongoClusters)",
        ["Storage encryption"] = "identity.type at the document root (NOT under properties.*, so not " +
            "template-addressable even once traced) — \"UserAssigned\" means customer-managed key, " +
            "anything else means service-managed (confirmed live on DocumentDB/mongoClusters)",
        ["Geo-replication"] = "AppConfiguration/configurationStores: the replica count comes from a " +
            "separate replicas-list API call (e.replicas?.length in the portal's own source), not this " +
            "type's resource GET body at all — genuinely a different-API-surface case, confirmed live " +
            "2026-08-14 on a Standard-tier store (the first time this tool ever captured one).",
        ["Purge protection"] = "properties.enablePurgeProtection, a real boolean — but only rendered " +
            "at all on a SKU tier where the feature exists, so an unresolved capture may just mean " +
            "the SKU didn't have the property to show (confirmed live on AppConfiguration/configurationStores)",
        ["Telemetry"] = "properties.telemetry.resourceId, existence-checked (present = Enabled) rather " +
            "than a literal boolean (confirmed live on AppConfiguration/configurationStores)",
        ["Cluster operation status"] = "properties.provisioningState, friendly-cased, compared against " +
            "a known list of in-progress states (Stopping/Starting/Upgrading/...) to decide whether to " +
            "show a spinner/badge (confirmed live on ContainerService/ManagedClusters — AKS)",
        ["Power state"] = "very likely properties.powerState.code (\"Running\"/\"Stopped\") — seen " +
            "passed through an opaque helper function, not inlined, so the exact path isn't 100% " +
            "confirmed the way the others here are",
        ["API server address"] = "very likely properties.fqdn or properties.privateFQDN — same opaque-" +
            "helper caveat as \"Power state\" above (confirmed live on ContainerService/ManagedClusters)",
        ["Node pools"] = "very likely a count/summary derived from properties.agentPoolProfiles — opaque " +
            "helper, exact shape not confirmed",
        ["Network configuration"] = "very likely composed from properties.networkProfile.networkPlugin " +
            "(+ networkPluginMode) — opaque helper, exact shape not confirmed",
        ["Created time"] = "AKS clusters fetch this from a SEPARATE API call, not the resource GET body " +
            "this tool captures at all — genuinely a different-API-surface case, not a parsing gap " +
            "(confirmed live on ContainerService/ManagedClusters; unrelated to the AKS/Storage " +
            "\"Date created\"/\"Created time\" cases already in NonTraceableLabels)",
        ["Definition"] = "a composite trigger/action-count summary computed from the whole workflow " +
            "resource, not a single property (confirmed live on Logic/workflows)",
        ["Runs last 24 hours"] = "fetched live from Azure Monitor metrics (RunsSucceeded/RunsFailed), " +
            "not present anywhere in the resource GET body — different-API-surface, not a parsing gap " +
            "(confirmed live on Logic/workflows)",
        ["Integration Account"] = "very likely properties.integrationAccount.id — opaque helper, exact " +
            "shape not confirmed (Logic/workflows)",
        ["Workflow Type"] = "opaque helper over the whole workflow resource — exact backing property " +
            "not confirmed (Logic/workflows)",
        ["Workflow URL"] = "fetched from a separate callback-URL API, not present in the resource GET " +
            "body — different-API-surface, not a parsing gap (confirmed live on Logic/workflows)",
        ["Max shares"] = "properties.maxShares, a real (usually-zero) number — direct passthrough, only " +
            "renders as \"0\" because no captured disk has sharing enabled (confirmed live on Compute/disks)",
        ["Managed by"] = "properties.managedBy (a VM resource ID, last path segment shown) when set — " +
            "genuinely composite (extracts + link-wraps a name from an ID, like the Resource Group " +
            "shortcut does), correctly non-traceable as a plain value match (confirmed live on Compute/disks)",
        ["Last ownership update time"] = "properties.LastOwnershipUpdateTime (note the unusual capital " +
            "L — a real quirk in this property's ARM casing, not a typo) — a genuine timestamp, just " +
            "null on every disk this tool has captured so far (confirmed live on Compute/disks)",
        ["Security type"] = "properties.securityProfile.securityType, via a friendly-casing transform " +
            "(confirmed live on Compute/disks)",
        ["Availability zone"] = "the root-level `zones` array (NOT under properties.*, so not template-" +
            "addressable even once traced), joined/sorted, with a \"No infrastructure redundancy " +
            "required\" fallback when empty (confirmed live on Compute/disks)",
        ["Compute type"] = "properties.computeType, capitalized — a plain direct passthrough (confirmed " +
            "live on Search/searchServices)",
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
            // Azure's generic fallback "Properties" form (see EssentialsExtractor's
            // PropertiesFormExtractItemsJs — used by types with no custom Overview blade extension,
            // e.g. Portal/dashboards, OperationalInsights/querypacks) renders this field as the full
            // "/subscriptions/{guid}" resource-path prefix rather than the bare GUID every other
            // layout uses — both forms are the same redacted identity, just a different rendering.
            ["Subscription ID"] = [OutputNormalizer.PlaceholderSubscriptionId, $"/subscriptions/{OutputNormalizer.PlaceholderSubscriptionId}"],
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
        "Time created", "Last modified", "Last Updated Date", "Time modified",
    };

    // Orthogonal to every other table here — resolvability (Kind) says whether we can find a
    // source for the value; this says whether that value is a durable setting someone chose
    // (SKU, Location, whether soft-delete is on) or a live, currently-observed condition that can
    // change independent of any configuration change and goes stale the moment the capture isn't
    // re-run (Status, a resource count, "last modified"). A vault note built from a one-time
    // capture is a snapshot, not a dashboard — a renderer needs to know which fields it's honestly
    // allowed to present as still-true today, without silently dropping the row and breaking
    // portal-layout parity. "Created"/"Creation date"/etc. are deliberately NOT here: a creation
    // instant is a historical fact, it never goes stale. "Updated"/"Last modified" are, though —
    // the value itself doesn't change retroactively, but it stops being *true* the next time the
    // real resource is touched, which a static capture has no way to know about.
    public static readonly HashSet<string> LiveStateLabels = new(StringComparer.OrdinalIgnoreCase)
    {
        "Status", "Provisioning state", "Updated", "Modified Time", "Last modified", "Last Updated Date",
        "App(s) / Slots", "Assigned host pools", "Inbound endpoints", "Virtual hubs",
        "Colocation status", "Operational issues", "Maintenance events",
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
            // Log Analytics workspace-only, only ever surfaced once this type's Overview extraction
            // actually started returning fields (2026-08-16) — a genuinely new gap, not a regression,
            // caught by PortalFieldsConsistencyTests as soon as this field became reachable at all.
            ["Access control mode"] = "enableLogAccessUsingOnlyResourcePermissions",
        };

    public static readonly Dictionary<string, bool> FriendlyBoolWords =
        new(StringComparer.OrdinalIgnoreCase)
        {
            ["Yes"] = true,
            ["No"] = false,
            ["Enabled"] = true,
            ["Disabled"] = false,
            ["Not enabled"] = false,
            // Log Analytics' own wording for the "Access control mode" boolean above — only
            // live-observed as `true` so far; the `false` case's own portal wording ("Require
            // workspace permissions", per Microsoft's docs) hasn't been live-verified against this
            // codebase's own "never guessed, always verified" standard, so it's deliberately NOT
            // added here yet.
            ["Use resource or workspace permissions"] = true,
        };

    // Lowercase + keep only letters/digits, so display formatting differences between the portal
    // (e.g. "West Europe") and the raw ARM JSON (e.g. "westeurope") don't cause false failures.
    public static string Normalize(string s) =>
        new string(s.Where(char.IsLetterOrDigit).ToArray()).ToLowerInvariant();

    // ─────────────────────────────────────────────────────────────────────────
    // Timestamp matching
    // ─────────────────────────────────────────────────────────────────────────

    private static readonly Regex WeekdayPrefix = new(@"^\p{L}+,\s*", RegexOptions.Compiled);
    // Norwegian portal language abbreviates the weekday with a trailing period instead of a comma
    // ("fre. 14. aug. 2026, ..." — "fre." = Friday) — a distinct shape from WeekdayPrefix above,
    // not just a different separator, since the day-of-month that follows also ends in a period.
    private static readonly Regex NorwegianWeekdayPrefix = new(@"^\p{L}{2,4}\.\s*", RegexOptions.Compiled);
    private static readonly Regex TrailingParenUtc = new(@"\s*\(UTC\)\s*$", RegexOptions.Compiled);
    private static readonly Regex TrailingBareUtc = new(@"\s*\bUTC\b\s*$", RegexOptions.Compiled);
    private static readonly Regex TrailingGmtOffset = new(@"\s*GMT([+-])(\d{1,2})\s*$", RegexOptions.Compiled);
    // Central European (Summer) Time abbreviations — this account's portal language renders in
    // Norwegian, whose timezone is CET (+01:00) / CEST (+02:00) during DST. .NET's date parser has
    // no built-in knowledge of timezone abbreviations (unlike numeric/GMT offsets above), so they're
    // translated to a numeric offset the same way TrailingGmtOffset is.
    private static readonly Regex TrailingCentralEuropeanTime = new(@"\s*\bCEST\b\s*$|\s*\bCET\b\s*$", RegexOptions.Compiled);
    private static readonly Regex AlreadyHasNumericOffset = new(@"(Z|[+-]\d{2}:\d{2})$", RegexOptions.Compiled);
    private static readonly Regex CollapseWhitespace = new(@"\s+", RegexOptions.Compiled);
    // "fre. 14. aug. 2026, 12:32:02 p.m. CEST" — Norwegian rendering also periods the AM/PM
    // designator, which .NET's nb-NO parser doesn't recognize as equivalent to its own "a"/"p".
    private static readonly Regex PeriodedMeridiem = new(@"\bp\.m\.|\ba\.m\.", RegexOptions.IgnoreCase | RegexOptions.Compiled);
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
        cleaned = NorwegianWeekdayPrefix.Replace(cleaned, "");
        cleaned = PeriodedMeridiem.Replace(cleaned, m => m.Value[0] is 'p' or 'P' ? "PM" : "AM");
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
        else if (TrailingCentralEuropeanTime.IsMatch(cleaned))
        {
            // CEST (summer/DST) is +02:00, plain CET (winter) is +01:00 — distinguish by which
            // literal matched rather than the date (no dependency on a timezone database).
            var isSummer = cleaned.TrimEnd().EndsWith("CEST", StringComparison.Ordinal);
            cleaned = TrailingCentralEuropeanTime.Replace(cleaned, isSummer ? " +02:00" : " +01:00");
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
            if (!TryParseDateAnyCulture(cleaned, out var naiveDate))
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
            if (!TryParseDateTimeOffsetAnyCulture(cleaned, out var portalInstant))
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
        if (!TryParseDateAnyCulture(cleaned, out var naive))
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

    // Live-observed (2026-08-14): this Azure account's portal language renders some timestamps in
    // Norwegian ("14. august 2026 kl. 12:41", "fre. 14. aug. 2026, 12:32:02 p.m. CEST") rather than
    // English — InvariantCulture can't parse a month/weekday name it's never seen. Tries nb-NO after
    // InvariantCulture fails, rather than assuming every capture renders in English.
    private static readonly CultureInfo[] FallbackCultures = [CultureInfo.InvariantCulture, new CultureInfo("nb-NO")];

    private static bool TryParseDateAnyCulture(string s, out DateTime result)
    {
        foreach (var culture in FallbackCultures)
        {
            if (DateTime.TryParse(s, culture, DateTimeStyles.None, out result))
            {
                return true;
            }
        }
        result = default;
        return false;
    }

    private static bool TryParseDateTimeOffsetAnyCulture(string s, out DateTimeOffset result)
    {
        foreach (var culture in FallbackCultures)
        {
            if (DateTimeOffset.TryParse(s, culture, DateTimeStyles.None, out result))
            {
                return true;
            }
        }
        result = default;
        return false;
    }

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
