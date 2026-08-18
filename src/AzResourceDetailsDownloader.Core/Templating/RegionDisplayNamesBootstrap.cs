using System.Runtime.CompilerServices;
using System.Text.Json;
using AzResourceDetailsDownloader.Options;
using AzResourceDetails.Templating;

namespace AzResourceDetailsDownloader.Templating;

// AzResourceDetails.Templating's RegionDisplayNames deliberately has no filesystem/repo-layout
// knowledge of its own (see its class comment) — it's configured by whichever host loads it. This
// is that host-side wiring for AzResourceDetailsDownloader specifically: load
// config/azure-locations.json (see fetch-azure-reference-data.ps1) via this repo's own RepoPaths,
// and hand the parsed table to the shared library once. A [ModuleInitializer] runs automatically
// the first time this assembly is loaded by any process (the CLI, or a test runner) — before any
// Core code that might call RegionDisplayNames.TryGetDisplayName — so every existing call site
// (FieldRecipeResolver's location shortcut, TemplateFunctions' region_display_name transform) keeps
// working exactly as it did when RegionDisplayNames loaded this file itself.
internal static class RegionDisplayNamesBootstrap
{
    // CA2255 normally steers module initializers away from library code — right in general, since
    // a class library shouldn't assume it's the whole process. Here it's a deliberate exception:
    // this Core project functionally IS the application root for its own repo-relative config
    // files (RepoPaths/config/azure-locations.json), and every existing call site into the shared
    // runtime's RegionDisplayNames needs this to have already run, with no call-site changes of
    // their own — see the class comment above.
#pragma warning disable CA2255
    [ModuleInitializer]
#pragma warning restore CA2255
    public static void Initialize() => RegionDisplayNames.Configure(Load());

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
