namespace AzResourceDetails.Templating.Tests;

// RegionDisplayNames has no filesystem/repo-layout knowledge of its own (see its class comment) —
// a host configures it explicitly. These tests exercise that seam directly, independent of any
// particular host's wiring (contrast AzResourceDetailsDownloader.Core's RegionDisplayNamesBootstrap,
// which is the real host-side loader for config/azure-locations.json).
public class RegionDisplayNamesTests
{
    [Fact]
    public void TryGetDisplayName_ConfiguredCode_ReturnsTrueAndTheDisplayName()
    {
        RegionDisplayNames.Configure(new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            ["norwayeast"] = "Norway East",
        });

        var found = RegionDisplayNames.TryGetDisplayName("norwayeast", out var displayName);

        Assert.True(found);
        Assert.Equal("Norway East", displayName);
    }

    [Fact]
    public void TryGetDisplayName_UnknownCode_ReturnsFalseAndEmptyString()
    {
        RegionDisplayNames.Configure(new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            ["norwayeast"] = "Norway East",
        });

        var found = RegionDisplayNames.TryGetDisplayName("not-a-real-region", out var displayName);

        Assert.False(found);
        Assert.Equal("", displayName);
    }

    // Before any host calls Configure, every lookup should just miss — the same graceful
    // degradation a missing/malformed reference-data file produced when this class loaded it
    // itself, not an exception.
    [Fact]
    public void TryGetDisplayName_BeforeConfigure_MissesGracefullyRatherThanThrowing()
    {
        RegionDisplayNames.Configure(new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase));

        var found = RegionDisplayNames.TryGetDisplayName("norwayeast", out var displayName);

        Assert.False(found);
        Assert.Equal("", displayName);
    }

    [Fact]
    public void Configure_CalledAgain_ReplacesThePreviousTableEntirely()
    {
        RegionDisplayNames.Configure(new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            ["norwayeast"] = "Norway East",
        });
        RegionDisplayNames.Configure(new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            ["westeurope"] = "West Europe",
        });

        Assert.False(RegionDisplayNames.TryGetDisplayName("norwayeast", out _));
        Assert.True(RegionDisplayNames.TryGetDisplayName("westeurope", out var displayName));
        Assert.Equal("West Europe", displayName);
    }
}
