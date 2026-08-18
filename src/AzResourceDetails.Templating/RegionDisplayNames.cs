namespace AzResourceDetails.Templating;

// The authoritative Azure region code -> portal display name map ("norwayeast" -> "Norway East"),
// e.g. from config/azure-locations.json (see fetch-azure-reference-data.ps1) in
// AzResourceDetailsDownloader. Deliberately does NOT load that file itself — this library has no
// filesystem or repository-layout knowledge of its own (see the class comment on
// AzResourceDetails.Templating.csproj's ItemGroup), so a host application resolves its own
// reference-data file and calls Configure once at startup. Before Configure is called, every
// lookup just misses — the same "no lookup available, treat as unverified" behavior a missing file
// produced before this became an explicit seam, so a host that forgets to call Configure degrades
// gracefully rather than throwing.
public static class RegionDisplayNames
{
    private static IReadOnlyDictionary<string, string> _map =
        new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

    /// <summary>
    /// Supplies the region-code -&gt; display-name table this library uses for
    /// <c>region_display_name</c>/<see cref="TryGetDisplayName"/>. Call once at host startup;
    /// safe to call again (e.g. in tests) to replace the table entirely.
    /// </summary>
    public static void Configure(IReadOnlyDictionary<string, string> regionDisplayNamesByCode) =>
        _map = regionDisplayNamesByCode;

    public static bool TryGetDisplayName(string regionCode, out string displayName)
    {
        if (_map.TryGetValue(regionCode, out var found))
        {
            displayName = found;
            return true;
        }
        displayName = "";
        return false;
    }
}
