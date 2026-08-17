using System.Text.Json;

namespace AzResourceDetailsDownloader.Config;

// A separate, hand-curated file — unlike ResourceAbbreviationsCatalog, nothing ever regenerates this one, so
// it can safely hold manual corrections for armTypes Microsoft's own table doesn't cover. Optional for the
// same reason as ResourceAbbreviationsLoader: a fresh checkout without it should just fall through to
// CategoryResolver's "uncategorized" bucket rather than hard-failing.
public static class CategoryOverridesLoader
{
    private static readonly JsonSerializerOptions SerializerOptions = new()
    {
        PropertyNameCaseInsensitive = true
    };

    public static CategoryOverridesCatalog? TryLoad(string path)
    {
        if (!File.Exists(path))
        {
            return null;
        }

        var json = File.ReadAllText(path);
        return JsonSerializer.Deserialize<CategoryOverridesCatalog>(json, SerializerOptions);
    }
}
