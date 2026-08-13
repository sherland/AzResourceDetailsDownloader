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

public sealed record FieldRecipe(FieldRecipeKind Kind, double Confidence, string? Target, string Notes);

// Resolves a captured portal Essentials label/value pair down to a "recipe" describing how a
// future template generator could reproduce it: a direct model.props.* path, a known transform
// (timestamp/boolean), a first-class model shortcut, or an explicit "can't be done mechanically"
// verdict with a reason. Combines two independent signals — does the value match, and does the
// property name resemble the label — because value-only matching produces real false positives
// (see NeedsReview below): a short common word like "Enabled" coincidentally equals some unrelated
// property's value more often than you'd expect across a whole ARM properties bag.
public static class FieldRecipeResolver
{
    private static readonly Dictionary<string, string> ShortcutLabels = new(StringComparer.OrdinalIgnoreCase)
    {
        ["Location"] = "model.location",
        ["Resource group"] = "model.resource_group",
    };

    // Deliberately does NOT include "Type" — its portal value is sometimes a friendly composite
    // string (e.g. Data Factory shows "Data factory (V2)", not the raw ARM type
    // "Microsoft.DataFactory/factories") rather than a literal passthrough, so it stays classified
    // via NonTraceableLabels/UnresolvedLabelHints instead of being short-circuited here.
    private static readonly string[] SkuLikeTokens = ["sku", "pricing"];

    public static FieldRecipe Resolve(string label, string value, JsonElement root)
    {
        if (ShortcutLabels.TryGetValue(label, out var shortcut))
        {
            return new FieldRecipe(FieldRecipeKind.Shortcut, 1.0, shortcut,
                "First-class model field — exact portal-text fidelity NOT verified here (e.g. " +
                "location is the raw ARM string like \"norwayeast\", not the portal's \"Norway East\"; " +
                "a real renderer needs its own formatting pass for this one, not just a path).");
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

        if (PortalFieldKnowledge.NonTraceableLabels.Contains(label))
        {
            var hint = PortalFieldKnowledge.UnresolvedLabelHints.TryGetValue(label, out var h)
                ? h
                : "composite/derived — no single backing property (see NonTraceableLabels comments)";
            return new FieldRecipe(FieldRecipeKind.Unresolved, 0.0, null, hint);
        }

        return ResolveGeneric(baseLabel, value, root);
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

        if (best.Similarity == 0)
        {
            var alt = addressable.Count > 1
                ? $" ({addressable.Count} addressable value-matching leaves, none name-related to the label)"
                : "";
            return new FieldRecipe(FieldRecipeKind.NeedsReview, 0.2, best.Target,
                $"Value matches ({best.Reason}) but the property name is unrelated to the label — " +
                $"verify by hand before trusting{alt}.");
        }

        if (runnerUp != default
            && runnerUp.Similarity >= best.Similarity - 0.01
            && runnerUp.Target != best.Target)
        {
            return new FieldRecipe(FieldRecipeKind.Ambiguous, best.Similarity, best.Target,
                $"Tied with {runnerUp.Target} (similarity {runnerUp.Similarity:0.00}) — pick manually.");
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
