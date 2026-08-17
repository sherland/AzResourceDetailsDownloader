using System.Text.Json;
using AzResourceDetailsDownloader.Capture;
using AzResourceDetailsDownloader.Output;

namespace AzResourceDetailsDownloader.Tests;

// Real file I/O against a throwaway temp directory per test — OutputWriter's whole job is writing
// files, so faking the filesystem would mean not actually testing what it does. No Azure/Playwright
// dependency; a temp directory is exactly as "unit-testable" as any other deterministic I/O.
public sealed class OutputWriterTests : IDisposable
{
    private readonly string _outputRoot = Path.Combine(Path.GetTempPath(), "ardl-output-writer-tests-" + Guid.NewGuid());

    public void Dispose()
    {
        if (Directory.Exists(_outputRoot))
        {
            Directory.Delete(_outputRoot, recursive: true);
        }
    }

    private static JsonDocument EmptyRawJson() => JsonDocument.Parse("""{"name":"example"}""");

    [Fact]
    public async Task WriteAsync_CreatesTheCategoryArmTypeDirectoryAndDataJson()
    {
        await OutputWriter.WriteAsync(
            _outputRoot, "Microsoft.KeyVault/vaults", "Security", EmptyRawJson(), screenshot: null,
            subscriptionId: "sub", tenantId: "tenant", actualRgName: "rg-example");

        var expectedDir = Path.Combine(_outputRoot, "security", "microsoft_keyvault_vaults");
        Assert.True(Directory.Exists(expectedDir));
        Assert.True(File.Exists(Path.Combine(expectedDir, "data.json")));
    }

    [Fact]
    public async Task WriteAsync_ScreenshotNull_DoesNotWritePortalPng()
    {
        await OutputWriter.WriteAsync(
            _outputRoot, "Microsoft.KeyVault/vaults", "Security", EmptyRawJson(), screenshot: null,
            subscriptionId: "sub", tenantId: "tenant", actualRgName: "rg-example");

        var pngPath = Path.Combine(_outputRoot, "security", "microsoft_keyvault_vaults", "portal.png");
        Assert.False(File.Exists(pngPath));
    }

    [Fact]
    public async Task WriteAsync_ScreenshotProvided_WritesPortalPngBytesVerbatim()
    {
        byte[] fakeScreenshot = [1, 2, 3, 4];

        await OutputWriter.WriteAsync(
            _outputRoot, "Microsoft.KeyVault/vaults", "Security", EmptyRawJson(), fakeScreenshot,
            subscriptionId: "sub", tenantId: "tenant", actualRgName: "rg-example");

        var pngPath = Path.Combine(_outputRoot, "security", "microsoft_keyvault_vaults", "portal.png");
        Assert.Equal(fakeScreenshot, await File.ReadAllBytesAsync(pngPath));
    }

    [Fact]
    public async Task WriteAsync_BicepAndTerraformProvided_WritesBothFiles()
    {
        await OutputWriter.WriteAsync(
            _outputRoot, "Microsoft.KeyVault/vaults", "Security", EmptyRawJson(), screenshot: null,
            subscriptionId: "sub", tenantId: "tenant", actualRgName: "rg-example",
            bicep: "resource vault 'Microsoft.KeyVault/vaults@2023-07-01' = {}",
            terraform: "resource \"azurerm_key_vault\" \"vault\" {}");

        var dir = Path.Combine(_outputRoot, "security", "microsoft_keyvault_vaults");
        Assert.True(File.Exists(Path.Combine(dir, "resource-group.bicep")));
        Assert.True(File.Exists(Path.Combine(dir, "resource-group.tf")));
    }

    [Fact]
    public async Task WriteAsync_BannerNoticesProvided_WritesNotesMdListingThem()
    {
        await OutputWriter.WriteAsync(
            _outputRoot, "Microsoft.KeyVault/vaults", "Security", EmptyRawJson(), screenshot: null,
            subscriptionId: "sub", tenantId: "tenant", actualRgName: "rg-example",
            bannerNotices: ["This feature is in preview.", "A newer API version is available."]);

        var notesPath = Path.Combine(_outputRoot, "security", "microsoft_keyvault_vaults", "notes.md");
        var content = await File.ReadAllTextAsync(notesPath);
        Assert.Contains("This feature is in preview.", content);
        Assert.Contains("A newer API version is available.", content);
    }

    // A previous run captured a banner that's no longer present (e.g. Azure removed the notice) —
    // the stale notes.md must not survive a re-run implying it's still current.
    [Fact]
    public async Task WriteAsync_NoBannerNoticesButStaleNotesMdExists_DeletesIt()
    {
        var dir = Path.Combine(_outputRoot, "security", "microsoft_keyvault_vaults");
        Directory.CreateDirectory(dir);
        await File.WriteAllTextAsync(Path.Combine(dir, "notes.md"), "# stale notice from a previous run");

        await OutputWriter.WriteAsync(
            _outputRoot, "Microsoft.KeyVault/vaults", "Security", EmptyRawJson(), screenshot: null,
            subscriptionId: "sub", tenantId: "tenant", actualRgName: "rg-example",
            bannerNotices: null);

        Assert.False(File.Exists(Path.Combine(dir, "notes.md")));
    }

    [Fact]
    public async Task WriteAsync_PortalFieldsProvided_WritesRedactedPortalFieldsJson()
    {
        await OutputWriter.WriteAsync(
            _outputRoot, "Microsoft.KeyVault/vaults", "Security", EmptyRawJson(), screenshot: null,
            subscriptionId: "sub", tenantId: "tenant", actualRgName: "rg-example",
            portalFields: [new PortalField("Resource group", "rg-example"), new PortalField("Location", "Norway East")]);

        var fieldsPath = Path.Combine(_outputRoot, "security", "microsoft_keyvault_vaults", "portal-fields.json");
        var content = await File.ReadAllTextAsync(fieldsPath);
        Assert.Contains("Resource group", content);
        Assert.Contains("Norway East", content);
    }

    [Fact]
    public async Task WriteAsync_NoPortalFieldsButStaleFileExists_DeletesIt()
    {
        var dir = Path.Combine(_outputRoot, "security", "microsoft_keyvault_vaults");
        Directory.CreateDirectory(dir);
        await File.WriteAllTextAsync(Path.Combine(dir, "portal-fields.json"), "[]");

        await OutputWriter.WriteAsync(
            _outputRoot, "Microsoft.KeyVault/vaults", "Security", EmptyRawJson(), screenshot: null,
            subscriptionId: "sub", tenantId: "tenant", actualRgName: "rg-example",
            portalFields: null);

        Assert.False(File.Exists(Path.Combine(dir, "portal-fields.json")));
    }
}
