using AzResourceDetailsDownloader.Capture;

namespace AzResourceDetailsDownloader.Tests;

public class PortalUrlBuilderTests
{
    [Fact]
    public void BuildOverviewUrl_ComposesTenantAndResourceIdIntoTheHashRoute()
    {
        var url = PortalUrlBuilder.BuildOverviewUrl(
            "https://portal.azure.com", "2b202f0f-b85b-4a41-a364-1de6f59bfd7c",
            "/subscriptions/sub-id/resourceGroups/rg-example/providers/Microsoft.KeyVault/vaults/kv-example");

        Assert.Equal(
            "https://portal.azure.com/#@2b202f0f-b85b-4a41-a364-1de6f59bfd7c/resource/subscriptions/sub-id/resourceGroups/rg-example/providers/Microsoft.KeyVault/vaults/kv-example/overview",
            url);
    }

    [Fact]
    public void BuildOverviewUrl_TrimsATrailingSlashFromThePortalBaseUrl()
    {
        var url = PortalUrlBuilder.BuildOverviewUrl("https://portal.azure.com/", "tenant", "/resourceId");

        Assert.StartsWith("https://portal.azure.com/#@tenant/", url);
    }
}
