using System.Text.Json;
using AzResourceDetailsDownloader.Options;

namespace AzResourceDetailsDownloader.Templating;

// Lazily loads config/azure-locations.json (see fetch-azure-reference-data.ps1) — the authoritative
// Azure region code -> portal display name map ("norwayeast" -> "Norway East"). Tolerates the file
// being absent (the script may never have been run yet, or this may be a test environment) by
// resolving to an empty map rather than throwing — a caller that gets no match for a region just
// falls back to treating it as unverified, the same as before this file existed.
public static class RegionDisplayNames
{
    private static readonly Lazy<IReadOnlyDictionary<string, string>> Map = new(Load);

    public static bool TryGetDisplayName(string regionCode, out string displayName)
    {
        if (Map.Value.TryGetValue(regionCode, out var found))
        {
            displayName = found;
            return true;
        }
        displayName = "";
        return false;
    }

    private static IReadOnlyDictionary<string, string> Load()
    {
        try
        {
            var repoRoot = RepoPaths.ResolveRepoRoot();
            var path = Path.Combine(repoRoot, "config", "azure-locations.json");
            if (!File.Exists(path))
            {
                return new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            }

            using var doc = JsonDocument.Parse(File.ReadAllText(path));
            var map = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            foreach (var entry in doc.RootElement.GetProperty("entries").EnumerateArray())
            {
                var name = entry.GetProperty("name").GetString();
                var displayName = entry.GetProperty("displayName").GetString();
                if (name is { Length: > 0 } && displayName is { Length: > 0 })
                {
                    map[name] = displayName;
                }
            }
            return map;
        }
        catch
        {
            // Best-effort — a malformed/partial fetch shouldn't break every resolution that touches
            // Location, just fall back to "no lookup available" the same as a missing file.
            return new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        }
    }
}
