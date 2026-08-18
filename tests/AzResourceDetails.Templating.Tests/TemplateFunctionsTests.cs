using Scriban.Runtime;

namespace AzResourceDetails.Templating.Tests;

public class TemplateFunctionsTests
{
    // This library has no filesystem/repo-layout knowledge of its own — RegionDisplayNames.
    // Configure is the seam a host normally wires up at startup (see
    // AzResourceDetailsDownloader.Core's RegionDisplayNamesBootstrap for the real one); tests
    // configure a small synthetic table instead of reaching for any real repo file.
    static TemplateFunctionsTests() =>
        RegionDisplayNames.Configure(new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            ["norwayeast"] = "Norway East",
        });

    [Theory]
    [InlineData(true, "Enabled")]
    [InlineData(false, "Disabled")]
    [InlineData(null, "")]
    public void PortalBoolEnabled_MapsToThePortalsOwnWording(bool? value, string expected)
    {
        Assert.Equal(expected, TemplateFunctions.PortalBoolEnabled(value));
    }

    [Theory]
    [InlineData(true, "Yes")]
    [InlineData(false, "No")]
    [InlineData(null, "")]
    public void PortalBoolYesNo_MapsToThePortalsOwnWording(bool? value, string expected)
    {
        Assert.Equal(expected, TemplateFunctions.PortalBoolYesNo(value));
    }

    [Fact]
    public void PortalTimestamp_ValidIsoString_FormatsAsPortalPlausibleText()
    {
        var result = TemplateFunctions.PortalTimestamp("2026-08-13T14:50:31Z");

        Assert.Equal("August 13, 2026 at 14:50:31 UTC", result);
    }

    [Theory]
    [InlineData(null)]
    [InlineData("")]
    public void PortalTimestamp_NullOrEmpty_ReturnsEmptyString(string? value)
    {
        Assert.Equal("", TemplateFunctions.PortalTimestamp(value));
    }

    [Fact]
    public void PortalTimestamp_UnparsableString_ReturnedVerbatimRatherThanGuessed()
    {
        Assert.Equal("not-a-timestamp", TemplateFunctions.PortalTimestamp("not-a-timestamp"));
    }

    [Fact]
    public void RegionDisplayName_KnownCode_ReturnsThePortalDisplayName()
    {
        // "norwayeast" is this file's static-constructor-configured synthetic table, not a real
        // repo file — see RegionDisplayNamesTests for the real one (fetched from the ARM Locations
        // API via fetch-azure-reference-data.ps1 in AzResourceDetailsDownloader, not guessed).
        Assert.Equal("Norway East", TemplateFunctions.RegionDisplayName("norwayeast"));
    }

    [Fact]
    public void RegionDisplayName_UnknownCode_ReturnedVerbatimRatherThanGuessed()
    {
        Assert.Equal("not-a-real-region", TemplateFunctions.RegionDisplayName("not-a-real-region"));
    }

    [Theory]
    [InlineData(null)]
    [InlineData("")]
    public void RegionDisplayName_NullOrEmpty_ReturnsEmptyString(string? value)
    {
        Assert.Equal("", TemplateFunctions.RegionDisplayName(value));
    }

    // A generated template calls these by name (portal_bool_enabled, portal_timestamp, ...) — the
    // actual contract with TemplateGenerator/TemplateRenderer is that ImportInto registers exactly
    // these four names, not just that the underlying static methods behave correctly in isolation.
    [Fact]
    public void ImportInto_RegistersAllFourFunctionsByTheirTemplateFacingNames()
    {
        var globals = new ScriptObject();

        TemplateFunctions.ImportInto(globals);

        Assert.True(globals.ContainsKey("portal_bool_enabled"));
        Assert.True(globals.ContainsKey("portal_bool_yesno"));
        Assert.True(globals.ContainsKey("portal_timestamp"));
        Assert.True(globals.ContainsKey("region_display_name"));
    }
}
