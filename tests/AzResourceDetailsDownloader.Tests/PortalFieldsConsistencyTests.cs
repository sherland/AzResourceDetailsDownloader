using System.Text.Json;
using AzResourceDetailsDownloader.Options;
using AzResourceDetailsDownloader.Templating;

namespace AzResourceDetailsDownloader.Tests;

// Cross-checks every committed output/{category}/{armType}/portal-fields.json against its sibling
// data.json — every Essentials field the portal showed should be traceable back to the real ARM
// JSON captured for the same resource. Catches a transcription mistake or a future
// EssentialsExtractor regression that starts inventing/misreading values.
//
// The label classification knowledge this test relies on (which labels are timestamps, which are
// a direct boolean rendering, which are tenant identity, which are genuinely composite/unresolved)
// lives in AzResourceDetailsDownloader.Templating.PortalFieldKnowledge — shared with
// FieldRecipeResolver (see FieldRecipeResolverTests) so the two never drift into disagreeing about
// the same label.
//
// Deliberately does NOT check portal-fields.inferred.json — by design (see AGENT.md) those are
// hand-transcribed from a third-party source for a resource type that was never actually
// captured on this subscription, so there is no matching data.json to check them against; the
// file's existence (and its sibling .sources.md) is what makes them honest, not this test.
public class PortalFieldsConsistencyTests
{
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
        var rawDataJson = File.ReadAllText(dataJsonPath);
        using var dataDoc = JsonDocument.Parse(rawDataJson);
        var normalizedDataJson = PortalFieldKnowledge.Normalize(rawDataJson);

        var problems = new List<string>();

        foreach (var f in fields)
        {
            if (PortalFieldKnowledge.TenantIdentityAllowedValues.TryGetValue(f.Label, out var allowedValues))
            {
                if (!allowedValues.Contains(f.Value, StringComparer.Ordinal))
                {
                    problems.Add($"{f.Label} = \"{f.Value}\" (expected one of: {string.Join(" / ", allowedValues)})");
                }
                continue;
            }

            if (PortalFieldKnowledge.NonTraceableLabels.Contains(f.Label))
            {
                continue;
            }

            if (PortalFieldKnowledge.TimestampLabels.Contains(f.Label)
                && PortalFieldKnowledge.TimestampIsTraceable(f.Value, dataDoc.RootElement))
            {
                continue;
            }

            if (PortalFieldKnowledge.BooleanBackedLabels.ContainsKey(f.Label)
                && PortalFieldKnowledge.BooleanBackedFieldMatches(f.Label, f.Value, dataDoc.RootElement))
            {
                continue;
            }

            var normalizedValue = PortalFieldKnowledge.Normalize(f.Value);
            if (normalizedValue.Length > 0 && !normalizedDataJson.Contains(normalizedValue))
            {
                problems.Add($"{f.Label} = \"{f.Value}\"");
            }
        }

        Assert.True(problems.Count == 0,
            $"{portalFieldsPath}: field(s) not found anywhere in the sibling data.json " +
            $"(compared case/punctuation-insensitively): {string.Join("; ", problems)}");
    }

    private sealed record PortalFieldRecord(string Label, string Value);
}
