using System.Diagnostics.CodeAnalysis;
using System.Text.Json;

namespace AzResourceDetailsDownloader.Templating;

// Plain data, no behavior — see NameRules.cs for why this is excluded rather than tested.
[ExcludeFromCodeCoverage]
public sealed record TemplateBatchResult(string ArmType, string TemplatePath, string RenderedPath, int TodoRowCount);

// Drives TemplateGenerator + TemplateRenderer across every real capture in output/ — deliberately
// only real portal-fields.json captures, never portal-fields.inferred.json: an inferred entry has
// no matching data.json, so there's nothing to build a Scriban model from or render against (same
// scoping PortalFieldsConsistencyTests already uses, for the same reason).
public static class TemplateBatchGenerator
{
    public static IReadOnlyList<TemplateBatchResult> GenerateAll(string outputRoot, string templatesDir)
    {
        var results = new List<TemplateBatchResult>();
        Directory.CreateDirectory(templatesDir);

        foreach (var portalFieldsPath in Directory.EnumerateFiles(outputRoot, "portal-fields.json", SearchOption.AllDirectories))
        {
            var dir = Path.GetDirectoryName(portalFieldsPath)!;
            var dataJsonPath = Path.Combine(dir, "data.json");
            if (!File.Exists(dataJsonPath))
            {
                continue;
            }

            using var dataDoc = JsonDocument.Parse(File.ReadAllText(dataJsonPath));
            var armType = dataDoc.RootElement.TryGetProperty("type", out var t) ? t.GetString() ?? "unknown" : "unknown";

            var fields = JsonSerializer.Deserialize<List<PortalFieldRecord>>(File.ReadAllText(portalFieldsPath)) ?? [];
            var fieldTuples = fields.Select(f => (f.Label, f.Value)).ToList();

            var templateText = TemplateGenerator.Generate(armType, fieldTuples, dataDoc.RootElement);
            var templatePath = Path.Combine(templatesDir, $"{TemplateGenerator.TypeToKey(armType)}.sbn");
            File.WriteAllText(templatePath, templateText);

            var rendered = TemplateRenderer.Render(templateText, dataDoc.RootElement, armType);
            var renderedPath = Path.Combine(dir, "rendered-preview.md");
            File.WriteAllText(renderedPath, rendered);

            var todoCount = templateText.Split("TODO (").Length - 1;
            results.Add(new TemplateBatchResult(armType, templatePath, renderedPath, todoCount));
        }

        return results;
    }
}
