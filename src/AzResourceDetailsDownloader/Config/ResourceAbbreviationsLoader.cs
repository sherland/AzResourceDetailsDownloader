using System.Text.Json;

namespace AzResourceDetailsDownloader.Config;

// Unlike ResourceTypeCatalogLoader (the tool's own required catalog), this file is produced by a separate,
// occasionally-run script (fetch-resource-abbreviations.ps1) — a fresh checkout or a run before that script
// has ever been executed shouldn't hard-fail, it should just fall back to CategoryResolver's "uncategorized"
// bucket for everything.
public static class ResourceAbbreviationsLoader
{
    private static readonly JsonSerializerOptions SerializerOptions = new()
    {
        PropertyNameCaseInsensitive = true
    };

    public static ResourceAbbreviationsCatalog? TryLoad(string path)
    {
        if (!File.Exists(path))
        {
            return null;
        }

        var json = File.ReadAllText(path);
        return JsonSerializer.Deserialize<ResourceAbbreviationsCatalog>(json, SerializerOptions);
    }
}
