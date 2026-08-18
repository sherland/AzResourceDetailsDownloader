namespace AzResourceDetails.Templating.Tests;

// RegionDisplayNames ships an embedded default (baked from AzResourceDetailsDownloader's own
// config/azure-locations.json — see the csproj's EmbeddedResource item and this class' own comment)
// so a host gets correct behavior without calling Configure at all; Configure/ResetToEmbeddedDefault
// are the explicit override/revert seam. Every test here calls one or the other at its own start
// rather than relying on execution order, since RegionDisplayNames' backing table is shared mutable
// static state across the whole assembly (see AssemblyInfo.cs' DisableTestParallelization).
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

    // A code that genuinely isn't a real Azure region should just miss gracefully, never throw —
    // true of the embedded default just as it always was of an empty/unconfigured table.
    [Fact]
    public void TryGetDisplayName_UnknownCode_AgainstEmbeddedDefault_MissesGracefullyRatherThanThrowing()
    {
        RegionDisplayNames.ResetToEmbeddedDefault();

        var found = RegionDisplayNames.TryGetDisplayName("not-a-real-region", out var displayName);

        Assert.False(found);
        Assert.Equal("", displayName);
    }

    // The whole point of embedding a default: a consumer that never calls Configure at all still
    // gets correct, portal-matching region names. "norwayeast" is a real, stable entry in
    // config/azure-locations.json (fetched from the ARM Locations API, not guessed).
    [Fact]
    public void TryGetDisplayName_KnownCode_AgainstEmbeddedDefault_ResolvesWithoutAnyConfigureCall()
    {
        RegionDisplayNames.ResetToEmbeddedDefault();

        var found = RegionDisplayNames.TryGetDisplayName("norwayeast", out var displayName);

        Assert.True(found);
        Assert.Equal("Norway East", displayName);
    }

    [Fact]
    public void ResetToEmbeddedDefault_UndoesAPreviousConfigureCall()
    {
        RegionDisplayNames.Configure(new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            ["westeurope"] = "West Europe",
        });
        Assert.False(RegionDisplayNames.TryGetDisplayName("norwayeast", out _));

        RegionDisplayNames.ResetToEmbeddedDefault();

        Assert.True(RegionDisplayNames.TryGetDisplayName("norwayeast", out var displayName));
        Assert.Equal("Norway East", displayName);
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
