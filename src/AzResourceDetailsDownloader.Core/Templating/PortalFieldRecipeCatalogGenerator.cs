using System.Diagnostics.CodeAnalysis;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace AzResourceDetailsDownloader.Templating;

public sealed record PortalFieldRecord(string Label, string Value);

// Plain data, no behavior — see NameRules.cs for why this is excluded rather than tested. (The
// generator logic that PRODUCES these entries is exercised via the corpus-driven tests instead.)
[ExcludeFromCodeCoverage]
public sealed record RecipeCatalogEntry(
    string Label,
    FieldRecipeKind Kind,
    double Confidence,
    string? Target,
    string Notes,
    bool IsLiveState,
    IReadOnlyList<string> ObservedArmTypes,
    string SampleValue,
    IReadOnlyDictionary<string, FieldRecipe>? Conflicts);

// Walks every committed output/{category}/{armType}/portal-fields.json + sibling data.json, runs
// FieldRecipeResolver over every field, and aggregates the results by LABEL (not by armType) — a
// given label almost always means the same thing everywhere it appears (see FieldRecipeResolver's
// class comment), so one catalog entry per label covers every type that shows it. When the same
// label genuinely resolves differently across types (a real conflict, not just noise), that's
// recorded explicitly per-armType instead of silently picking one — most commonly this will be a
// "vocabulary"-kind label like "Status" that the resolver already routes to NonTraceableLabels
// (so it won't conflict in practice), but the check stays generic so a real surprise gets caught.
public static class PortalFieldRecipeCatalogGenerator
{
    private static readonly JsonSerializerOptions WriteOptions = new()
    {
        WriteIndented = true,
        Converters = { new JsonStringEnumConverter() },
    };

    public static IReadOnlyList<RecipeCatalogEntry> Generate(string outputRoot)
    {
        var byLabel = new Dictionary<string, List<(string ArmType, FieldRecipe Recipe, string Value)>>(
            StringComparer.OrdinalIgnoreCase);

        foreach (var portalFieldsPath in Directory.EnumerateFiles(outputRoot, "portal-fields.json", SearchOption.AllDirectories))
        {
            var dataJsonPath = Path.Combine(Path.GetDirectoryName(portalFieldsPath)!, "data.json");
            if (!File.Exists(dataJsonPath))
            {
                continue;
            }

            using var dataDoc = JsonDocument.Parse(File.ReadAllText(dataJsonPath));
            var armType = dataDoc.RootElement.TryGetProperty("type", out var t) ? t.GetString() ?? "unknown" : "unknown";

            var fields = JsonSerializer.Deserialize<List<PortalFieldRecord>>(File.ReadAllText(portalFieldsPath)) ?? [];
            foreach (var field in fields)
            {
                var recipe = FieldRecipeResolver.Resolve(field.Label, field.Value, dataDoc.RootElement, armType);
                if (!byLabel.TryGetValue(field.Label, out var observations))
                {
                    observations = [];
                    byLabel[field.Label] = observations;
                }
                observations.Add((armType, recipe, field.Value));
            }
        }

        var entries = new List<RecipeCatalogEntry>();
        foreach (var (label, observations) in byLabel.OrderBy(kv => kv.Key, StringComparer.OrdinalIgnoreCase))
        {
            var distinctResolutions = observations.Select(o => (o.Recipe.Kind, o.Recipe.Target)).Distinct().ToList();
            var primary = observations[0];

            IReadOnlyDictionary<string, FieldRecipe>? conflicts = distinctResolutions.Count > 1
                ? observations
                    .GroupBy(o => o.ArmType, StringComparer.OrdinalIgnoreCase)
                    .ToDictionary(g => g.Key, g => g.First().Recipe, StringComparer.OrdinalIgnoreCase)
                : null;

            entries.Add(new RecipeCatalogEntry(
                label,
                primary.Recipe.Kind,
                primary.Recipe.Confidence,
                primary.Recipe.Target,
                primary.Recipe.Notes,
                primary.Recipe.IsLiveState,
                observations.Select(o => o.ArmType).Distinct(StringComparer.OrdinalIgnoreCase)
                    .OrderBy(a => a, StringComparer.OrdinalIgnoreCase).ToList(),
                primary.Value,
                conflicts));
        }

        return entries;
    }

    public static void WriteCatalog(IReadOnlyList<RecipeCatalogEntry> entries, string outputPath)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(outputPath)!);
        File.WriteAllText(outputPath, JsonSerializer.Serialize(entries, WriteOptions));
    }

    public static string Summarize(IReadOnlyList<RecipeCatalogEntry> entries)
    {
        var byKind = entries
            .GroupBy(e => e.Kind)
            .OrderByDescending(g => g.Count())
            .Select(g => $"{g.Key}={g.Count()}");
        var conflictCount = entries.Count(e => e.Conflicts is not null);
        return $"{entries.Count} labels — {string.Join(", ", byKind)}" +
            (conflictCount > 0 ? $" — {conflictCount} label(s) with cross-armType conflicts, see catalog" : "");
    }
}
