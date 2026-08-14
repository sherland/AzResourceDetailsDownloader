using System.Globalization;
using System.Text.Json;
using System.Text.RegularExpressions;

namespace AzResourceDetailsDownloader.Templating;

public enum FieldRecipeKind
{
    Shortcut,
    ShortcutVerified,
    ShortcutCasingMismatch,
    ShortcutMismatch,
    Context,
    Timestamp,
    NotAddressable,
    TimestampUnresolved,
    Boolean,
    Direct,
    NeedsReview,
    Ambiguous,
    Unresolved,
}

// IsLiveState marks a label as PortalFieldKnowledge.LiveStateLabels does — a currently-observed
// condition rather than a durable setting — independent of Kind/Target/Confidence entirely. A
// renderer should still emit this field's row (dropping it breaks portal-layout parity), but treat
// the value as a "true as of the last capture" snapshot rather than a current fact: e.g. append a
// captured-at caveat, or — when Kind is Unresolved/NotAddressable, meaning there's no captured
// value to show at all (VM power state isn't in the capture body) — render an explicit
// "see the Azure Portal for current status" placeholder instead of silently omitting the row.
public sealed record FieldRecipe(FieldRecipeKind Kind, double Confidence, string? Target, string Notes, bool IsLiveState = false);

// Resolves a captured portal Essentials label/value pair down to a "recipe" describing how a
// future template generator could reproduce it: a direct model.props.* path, a known transform
// (timestamp/boolean), a first-class model shortcut, or an explicit "can't be done mechanically"
// verdict with a reason. Combines two independent signals — does the value match, and does the
// property name resemble the label — because value-only matching produces real false positives
// (see NeedsReview below): a short common word like "Enabled" coincidentally equals some unrelated
// property's value more often than you'd expect across a whole ARM properties bag.
public static class FieldRecipeResolver
{
    // Deliberately does NOT include "Type" — its portal value is sometimes a friendly composite
    // string (e.g. Data Factory shows "Data factory (V2)", not the raw ARM type
    // "Microsoft.DataFactory/factories") rather than a literal passthrough, so it stays classified
    // via NonTraceableLabels/UnresolvedLabelHints instead of being short-circuited here.
    private static readonly string[] SkuLikeTokens = ["sku", "pricing"];

    // NonTraceableLabels blanket-skips these for the consistency test's purposes (a label genuinely
    // can't be verified for every type it appears on), but that doesn't mean NO type resolves it —
    // "Status" turned out to be three different problems wearing one label: Container Registry's
    // "Status" is a plain passthrough of provisioningState, Redis's is a composite (provisioningState
    // translated PLUS a SKU-size lookup appended), and the VM's isn't captured at all (power state
    // lives behind a separate API call). Rather than accept the label-level generalization, let these
    // fall through to the generic resolver per (ArmType, label) and see what's actually there —
    // ResolveGeneric harmlessly returns Unresolved (with the fallback hint reattached, see Resolve)
    // when nothing's found, so trying costs nothing.
    private static readonly HashSet<string> AttemptDespiteNonTraceableHint = new(StringComparer.OrdinalIgnoreCase)
    {
        "Status", "Managed", "Forward messages to", "Dead lettering", "Automatic failover enabled",
        "Non-TLS access", "Autoscale", "Availability zones", "Availability zone",
        "Public network access", "Managed virtual network", "Auto-inflate throughput units",
        // Missed in the original "Status" investigation despite being found live: Container
        // Registry's "Provisioning state" is a plain passthrough of properties.provisioningState —
        // caught by actually generating a template and finding it fall back to a TODO row it
        // shouldn't have needed, not by re-auditing the label list.
        "Provisioning state",
        // The "different API surface" bucket had the same problem: Application Insights stores its
        // "Instrumentation key"/"Connection string" as plain resource properties (unlike, say,
        // Storage Account keys, which genuinely do require a separate listKeys call), and SSH
        // Public Keys' "Public key" is a direct properties.publicKey passthrough. Attempting these
        // costs nothing where the original classification was actually right (URL, Account URI,
        // Queue/Topic URL, Logs workspace, Metrics ingestion endpoint, Origin response timeout,
        // Ports all correctly stay Unresolved) — "Endpoint" lands on a genuinely mixed
        // Ambiguous/NeedsReview/Unresolved verdict per type, which is more honest than a blanket
        // skip either way.
        "Endpoint", "URL", "Account URI", "Queue URL", "Topic URL", "Instrumentation key",
        "Connection string", "Logs workspace", "Metrics ingestion endpoint", "Origin response timeout",
        "Public key", "Ports",

        // Confirmed by reading the live Azure Portal's own field-builder source via a React fiber
        // walk (2026-08-14 pilot — see EssentialsExtractor.DumpFiberBuilderSourceAsync and AGENT.md),
        // not by guessing: Compute/disks' "Operating system" is a direct, untransformed
        // `properties.osType` passthrough (it only ever *looked* composite because this tool's own
        // disk captures are always unattached data disks with osType null, rendering as "-"); "Disk
        // size" is the same shape on both disks (`properties.diskSizeGB`) and Mongo vCore clusters
        // (`properties.storage.sizeGb`) — a plain number plus a " GiB" unit suffix, not a real
        // composite; Search Services' "Replicas" is `properties.replicaCount` wrapped in a
        // count-formatter (adds "(No SLA)" only when the count is 1). Attempting these costs nothing
        // where a type's value happens to be empty/placeholder (falls through to Unresolved exactly
        // as before) and gets a real match where it isn't.
        "Operating system", "Disk size", "Replicas",
    };

    public static FieldRecipe Resolve(string label, string value, JsonElement root)
    {
        var recipe = ResolveCore(label, value, root);
        return recipe with { IsLiveState = PortalFieldKnowledge.LiveStateLabels.Contains(label) };
    }

    private static FieldRecipe ResolveCore(string label, string value, JsonElement root)
    {
        if (label.Equals("Location", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveLocationShortcut(value, root);
        }
        if (label.Equals("Resource group", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveResourceGroupShortcut(value, root);
        }

        var (baseLabel, _) = StripParenthetical(label);
        if (SkuLikeTokens.Any(t => Tokenize(baseLabel).Contains(t)))
        {
            return ResolveSkuShortcut(value, root);
        }

        if (PortalFieldKnowledge.TenantIdentityAllowedValues.TryGetValue(label, out var allowed))
        {
            return allowed.Contains(value, StringComparer.Ordinal)
                ? new FieldRecipe(FieldRecipeKind.Context, 1.0, null,
                    "Tenant/subscription identity — already covered by frontmatter, omit from body")
                : new FieldRecipe(FieldRecipeKind.Context, 0.0, null,
                    $"WARNING: value \"{value}\" doesn't match the expected placeholder " +
                    $"({string.Join(" / ", allowed)}) — check OutputNormalizer redaction before trusting this capture");
        }

        if (PortalFieldKnowledge.TimestampLabels.Contains(label))
        {
            return ResolveTimestamp(baseLabel, value, root);
        }

        if (PortalFieldKnowledge.BooleanBackedLabels.ContainsKey(label))
        {
            return ResolveKnownBoolean(label, value, root);
        }

        if (PortalFieldKnowledge.NonTraceableLabels.Contains(label) && !AttemptDespiteNonTraceableHint.Contains(label))
        {
            var hint = PortalFieldKnowledge.UnresolvedLabelHints.TryGetValue(label, out var h)
                ? h
                : "composite/derived — no single backing property (see NonTraceableLabels comments)";
            return new FieldRecipe(FieldRecipeKind.Unresolved, 0.0, null, hint);
        }

        var generic = ResolveGeneric(baseLabel, value, root);

        // The generic resolver found nothing for THIS specific (armType, label) — fall back to the
        // richer, previously-known reason (e.g. "vocabulary" / "composite of X + Y") instead of its
        // generic "no value match found" message, so a type where this genuinely doesn't resolve
        // still reads as informative as it did before AttemptDespiteNonTraceableHint existed.
        if (generic.Kind == FieldRecipeKind.Unresolved
            && PortalFieldKnowledge.UnresolvedLabelHints.TryGetValue(label, out var fallbackHint))
        {
            return generic with { Notes = fallbackHint };
        }

        return generic;
    }

    private static FieldRecipe ResolveSkuShortcut(string value, JsonElement root)
    {
        var computed = SkuAndVersion.SkuLabel(root);
        if (computed is null)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutMismatch, 0.0, "model.sku_label",
                $"portal shows \"{value}\" but no sku object found at root or properties.sku");
        }
        if (computed == value)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutVerified, 1.0, "model.sku_label",
                "Verified: computed sku_label matches the captured portal value exactly.");
        }
        if (PortalFieldKnowledge.Normalize(computed) == PortalFieldKnowledge.Normalize(value))
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutCasingMismatch, 0.7, "model.sku_label",
                $"Computed \"{computed}\" vs portal \"{value}\" — same value, different casing/formatting. " +
                "Usable, but the renderer needs its own text fixup to match the portal exactly.");
        }
        return new FieldRecipe(FieldRecipeKind.ShortcutMismatch, 0.0, "model.sku_label",
            $"Computed \"{computed}\" does NOT match portal \"{value}\" for this type — do not trust this shortcut here.");
    }

    // "norwayeast" -> "Norway East" via config/azure-locations.json (fetch-azure-reference-data.ps1)
    // — the raw ARM location code is never the portal's display text, so this always needed a real
    // lookup, not just a path. Normalize()-equality alone would already bridge most regions (they're
    // literally the display name with spaces/casing stripped), but the fetched table is used instead
    // of relying on that always holding — it's the authoritative source, not an assumption.
    private static FieldRecipe ResolveLocationShortcut(string value, JsonElement root)
    {
        var rawLocation = JsonTree.GetString(root, "location");
        if (rawLocation is null)
        {
            return new FieldRecipe(FieldRecipeKind.Unresolved, 0.0, null, "This capture has no root 'location' field.");
        }

        // Not every resource provider returns the usual lowercase ARM code — live-observed:
        // Notification Hubs, App Service Plans, and others return "location" already in display
        // form ("Norway East"), and non-regional values like "global"/"Global" are legitimate,
        // stable location values with no entry in the physical-regions-only lookup table anyway.
        // Check direct equality before consulting the lookup, so both shapes verify correctly
        // instead of the display-form/global cases falling through to "not in table".
        if (rawLocation == value)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutVerified, 1.0, "model.location",
                "Verified: this capture's raw 'location' is already in display form, matches the portal exactly.");
        }
        if (string.Equals(rawLocation, value, StringComparison.OrdinalIgnoreCase))
        {
            // e.g. Azure Maps: raw "global" vs portal "Global" — a non-regional value, so it was
            // never going to be in the physical-regions lookup below either way.
            return new FieldRecipe(FieldRecipeKind.ShortcutCasingMismatch, 0.7, "model.location",
                $"Raw \"{rawLocation}\" vs portal \"{value}\" — same value, different casing.");
        }

        if (!RegionDisplayNames.TryGetDisplayName(rawLocation, out var displayName))
        {
            return new FieldRecipe(FieldRecipeKind.Shortcut, 0.3, "model.location",
                $"Region '{rawLocation}' isn't in config/azure-locations.json (stale fetch, or a new/preview " +
                "region) — falling back to the raw ARM value, unverified. Re-run fetch-azure-reference-data.ps1.");
        }

        if (displayName == value)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutVerified, 1.0, "model.location",
                "Verified via config/azure-locations.json — transform: region_display_name.");
        }

        return new FieldRecipe(FieldRecipeKind.ShortcutMismatch, 0.0, "model.location",
            $"config/azure-locations.json says '{rawLocation}' displays as \"{displayName}\", but the portal " +
            $"showed \"{value}\" — investigate before trusting this shortcut for this type.");
    }

    private static readonly Regex ResourceGroupFromId = new(@"/resourceGroups/([^/]+)/", RegexOptions.IgnoreCase | RegexOptions.Compiled);

    // The resource group name isn't a separate field in a raw ARM GET response — only embedded in
    // `id` — but since OutputNormalizer redacts it to the same placeholder everywhere it appears
    // (both inside `id` and in the portal's own "Resource group" field), no formatting transform is
    // needed here, just extraction and an exact comparison.
    private static FieldRecipe ResolveResourceGroupShortcut(string value, JsonElement root)
    {
        var id = JsonTree.GetString(root, "id");
        var match = id is null ? null : ResourceGroupFromId.Match(id);
        if (match is not { Success: true })
        {
            return new FieldRecipe(FieldRecipeKind.Unresolved, 0.0, null,
                "Couldn't extract a resource group name from this capture's 'id' field.");
        }

        var extracted = match.Groups[1].Value;
        if (extracted == value)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutVerified, 1.0, "model.resource_group",
                "Verified: resource group name extracted from 'id' matches the portal value exactly.");
        }
        if (string.Equals(extracted, value, StringComparison.OrdinalIgnoreCase))
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutCasingMismatch, 0.7, "model.resource_group",
                $"Extracted \"{extracted}\" vs portal \"{value}\" — same value, different casing.");
        }
        return new FieldRecipe(FieldRecipeKind.ShortcutMismatch, 0.0, "model.resource_group",
            $"Extracted \"{extracted}\" from 'id' but the portal showed \"{value}\" — investigate.");
    }

    private static FieldRecipe ResolveTimestamp(string baseLabel, string value, JsonElement root)
    {
        var allPaths = PortalFieldKnowledge.FindTimestampMatchingPaths(value, root);
        var addressable = allPaths.Where(p => p.StartsWith("properties.", StringComparison.Ordinal)).ToList();

        if (addressable.Count > 0)
        {
            var best = RankByNameSimilarity(baseLabel, addressable);
            var target = $"model.props.{StripPropertiesPrefix(best)}";
            return new FieldRecipe(FieldRecipeKind.Timestamp, 0.9, target,
                addressable.Count > 1
                    ? $"transform: portal_timestamp — {addressable.Count} candidate instants matched, picked by label/property-name similarity"
                    : "transform: portal_timestamp");
        }

        if (allPaths.Count > 0)
        {
            return new FieldRecipe(FieldRecipeKind.NotAddressable, 0.0, null,
                $"Traceable via '{allPaths[0]}', but that's outside properties.* — not reachable as model.props.*. " +
                "Would need the renderer to expose that section, or the label stays manual.");
        }

        return new FieldRecipe(FieldRecipeKind.TimestampUnresolved, 0.0, null,
            "Labeled as a timestamp but no matching ISO instant found anywhere in this capture.");
    }

    private static FieldRecipe ResolveKnownBoolean(string label, string value, JsonElement root)
    {
        var path = PortalFieldKnowledge.FindBooleanBackedPath(label, value, root);
        if (path is null)
        {
            return new FieldRecipe(FieldRecipeKind.Unresolved, 0.0, null,
                $"Expected boolean-backed property for '{label}' not found in this capture.");
        }
        if (!path.StartsWith("properties.", StringComparison.Ordinal))
        {
            return new FieldRecipe(FieldRecipeKind.NotAddressable, 0.0, null,
                $"Traceable via '{path}', but that's outside properties.* — not reachable as model.props.*.");
        }
        return new FieldRecipe(FieldRecipeKind.Boolean, 0.95, $"model.props.{StripPropertiesPrefix(path)}",
            "transform: portal_bool (known-verified label→property mapping)");
    }

    // Dual-signal resolution for everything not already covered by a known table: a value match
    // alone isn't enough — short friendly words like "Enabled"/"2"/"Basic" collide across unrelated
    // properties in a typical ARM properties bag — so rank candidates by how closely the label's
    // words resemble the matched property's own name, and only take a value match at face value
    // when it's also the best name match.
    //
    // Searches the WHOLE document, not just properties.* — a first pass that scoped this to
    // properties.* alone missed real matches sitting in ARM's root-level "kind"/"name"/"id" blocks
    // (sibling to properties, not inside it). Addressability is then judged per-candidate via
    // AddressableTarget: a match under properties.* or one of the handful of first-class model
    // fields is usable; anything else (systemData, tags, sku's raw name/tier once already covered
    // by the SKU shortcut, etc.) is traceable but not reachable from a template, and reported as
    // NotAddressable instead of a misleading blanket "no match found".
    private static FieldRecipe ResolveGeneric(string baseLabel, string value, JsonElement root)
    {
        var nVal = PortalFieldKnowledge.Normalize(value);
        var candidates = new List<(string ScribanPath, string OriginalPath, double Similarity, string Reason)>();

        foreach (var leaf in JsonTree.Flatten(root))
        {
            var (matched, reason) = TryMatchLeafValue(leaf.Value, nVal);
            if (!matched)
            {
                continue;
            }
            candidates.Add((leaf.ScribanPath, leaf.OriginalPath, NameSimilarity(baseLabel, leaf.OriginalPath), reason));
        }

        if (candidates.Count == 0)
        {
            return new FieldRecipe(FieldRecipeKind.Unresolved, 0.0, null,
                "No value match found anywhere in this capture — investigate before adding to any known table " +
                "(could be a genuine EssentialsExtractor/redaction bug, a portal empty-state placeholder like " +
                "\"---\", or a new different-API-surface/composite case).");
        }

        candidates = candidates.OrderByDescending(c => c.Similarity).ToList();
        var bestOverall = candidates[0];
        var addressable = candidates
            .Select(c => (c.ScribanPath, c.Similarity, c.Reason, Target: AddressableTarget(c.OriginalPath, c.ScribanPath)))
            .Where(c => c.Target is not null)
            .OrderByDescending(c => c.Similarity)
            .ToList();

        if (addressable.Count == 0)
        {
            return new FieldRecipe(FieldRecipeKind.NotAddressable, 0.0, null,
                $"Traceable via '{bestOverall.ScribanPath}' ({bestOverall.Reason}), but that's outside " +
                "properties.*/kind/name/id/location — not reachable from a template.");
        }

        var best = addressable[0];
        var runnerUp = addressable.Count > 1 ? addressable[1] : default;

        // A single weak token match (e.g. "messages" fuzzy-stemming against "message", or a
        // generic word like "managed" appearing in an otherwise unrelated property path) is not
        // enough to trust blindly — that's exactly how "Forward messages to" matched
        // deadLetteringOnMessageExpiration and "Managed virtual network" matched
        // defaultDataLakeStorage.createManagedPrivateEndpoint, both wrong, both live-caught here.
        // Require at least half the label's words to be reflected in the property name before
        // calling it Direct.
        if (best.Similarity < 0.5)
        {
            var alt = addressable.Count > 1
                ? $" ({addressable.Count} addressable value-matching leaves, none strongly name-related to the label)"
                : "";
            return new FieldRecipe(FieldRecipeKind.NeedsReview, 0.2, best.Target,
                $"Value matches ({best.Reason}) but the property name is only weakly related to the label " +
                $"(similarity {best.Similarity.ToString("0.00", CultureInfo.InvariantCulture)}) — " +
                $"verify by hand before trusting{alt}.");
        }

        if (runnerUp != default
            && runnerUp.Similarity >= best.Similarity - 0.01
            && runnerUp.Target != best.Target)
        {
            return new FieldRecipe(FieldRecipeKind.Ambiguous, best.Similarity, best.Target,
                $"Tied with {runnerUp.Target} " +
                $"(similarity {runnerUp.Similarity.ToString("0.00", CultureInfo.InvariantCulture)}) — pick manually.");
        }

        return new FieldRecipe(FieldRecipeKind.Direct, best.Similarity, best.Target, best.Reason);
    }

    // The handful of places outside properties.* that a template can still reach: properties.* maps
    // to model.props.*; ARM's root-level "kind" column is merged into model.props.kind whenever
    // properties doesn't already define it (Cognitive Services' "API Kind", etc.); "name"/"id" are
    // their own first-class model fields. Everything else found elsewhere in the document (tags,
    // systemData, identity, sku's raw sub-fields once the SKU shortcut already covers those,
    // cross-referenced related-resource IDs) is real data but genuinely not template-addressable
    // today.
    private static string? AddressableTarget(string originalPath, string scribanPath)
    {
        if (originalPath.StartsWith("properties.", StringComparison.OrdinalIgnoreCase))
        {
            return $"model.props.{StripPropertiesPrefix(scribanPath)}";
        }
        return originalPath.ToLowerInvariant() switch
        {
            "kind" => "model.props.kind",
            "name" => "model.name",
            "id" => "model.id",
            "location" => "model.location",
            "type" => "model.type",
            _ => null,
        };
    }

    private static (bool Matched, string Reason) TryMatchLeafValue(JsonElement leaf, string normalizedPortalValue)
    {
        if (leaf.ValueKind is JsonValueKind.True or JsonValueKind.False)
        {
            var isTrue = leaf.ValueKind is JsonValueKind.True;
            string[] words = isTrue ? ["Enabled", "Yes", "On"] : ["Disabled", "No", "Off", "Not enabled"];
            return words.Any(w => PortalFieldKnowledge.Normalize(w) == normalizedPortalValue)
                ? (true, "boolean→friendly-word")
                : (false, "");
        }

        var leafText = leaf.ValueKind switch
        {
            JsonValueKind.String => leaf.GetString(),
            JsonValueKind.Number => leaf.GetRawText(),
            _ => null,
        };
        if (leafText is not null
            && normalizedPortalValue.Length > 0
            && PortalFieldKnowledge.Normalize(leafText) == normalizedPortalValue)
        {
            return (true, "exact value match");
        }

        return (false, "");
    }

    private static string StripPropertiesPrefix(string scribanPath) =>
        scribanPath.StartsWith("properties.", StringComparison.Ordinal)
            ? scribanPath["properties.".Length..]
            : scribanPath;

    private static string RankByNameSimilarity(string baseLabel, IReadOnlyList<string> scribanPaths) =>
        scribanPaths
            .Select(p => (Path: p, Score: NameSimilarity(baseLabel, p)))
            .OrderByDescending(p => p.Score)
            .First()
            .Path;

    private static (string Base, string? Parenthetical) StripParenthetical(string label)
    {
        var m = Regex.Match(label, @"^(.*?)\s*\(([^)]+)\)\s*$");
        return m.Success ? (m.Groups[1].Value.Trim(), m.Groups[2].Value) : (label, null);
    }

    private static HashSet<string> Tokenize(string s)
    {
        var tokens = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (var word in Regex.Split(s, @"[^A-Za-z]+").Where(w => w.Length > 0))
        {
            foreach (var part in Regex.Split(word, "(?<=[a-z0-9])(?=[A-Z])"))
            {
                if (part.Length > 0)
                {
                    tokens.Add(part.ToLowerInvariant());
                }
            }
        }
        return tokens;
    }

    private static double NameSimilarity(string label, string propertyPath)
    {
        var labelTokens = Tokenize(label);
        if (labelTokens.Count == 0)
        {
            return 0;
        }
        var pathTokens = Tokenize(propertyPath);
        var hits = labelTokens.Count(lt => pathTokens.Any(pt =>
            pt.Equals(lt, StringComparison.OrdinalIgnoreCase)
            || pt.StartsWith(lt, StringComparison.OrdinalIgnoreCase)
            || lt.StartsWith(pt, StringComparison.OrdinalIgnoreCase)));
        return (double)hits / labelTokens.Count;
    }
}
