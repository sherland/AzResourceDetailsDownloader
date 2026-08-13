using AzResourceDetailsDownloader.Capture;
using AzResourceDetailsDownloader.Output;

namespace AzResourceDetailsDownloader.Tests;

public class OutputNormalizerTests
{
    [Fact]
    public void Normalize_ReplacesSubscriptionTenantAndRgName()
    {
        const string subscriptionId = "e78cb18c-eccd-4470-9986-29c3a1a58654";
        const string tenantId = "8b87af7d-8647-4dc7-8df4-5f69a2011bb5";
        const string rgName = "rg-ardl-abcdef0123456789";
        var text = $$"""{"id": "/subscriptions/{{subscriptionId}}/resourceGroups/{{rgName}}", "tenant": "{{tenantId}}"}""";

        var result = OutputNormalizer.Normalize(text, subscriptionId, tenantId, rgName, "Microsoft.Storage/storageAccounts");

        Assert.Contains(OutputNormalizer.PlaceholderSubscriptionId, result);
        Assert.Contains(OutputNormalizer.PlaceholderTenantId, result);
        Assert.DoesNotContain(subscriptionId, result);
        Assert.DoesNotContain(tenantId, result);
        Assert.DoesNotContain(rgName, result);
    }

    [Fact]
    public void Normalize_UsesDistinctPlaceholders_ForSubscriptionAndTenant()
    {
        Assert.NotEqual(OutputNormalizer.PlaceholderSubscriptionId, OutputNormalizer.PlaceholderTenantId);
    }

    [Fact]
    public void Normalize_IsCaseInsensitive()
    {
        const string subscriptionId = "e78cb18c-eccd-4470-9986-29c3a1a58654";
        var text = $"Value: {subscriptionId.ToUpperInvariant()}";

        var result = OutputNormalizer.Normalize(text, subscriptionId, "tenant-id-placeholder", "rg-name", "Microsoft.Storage/storageAccounts");

        Assert.Contains(OutputNormalizer.PlaceholderSubscriptionId, result);
    }

    [Fact]
    public void Normalize_RgNamePlaceholder_IsDeterministicPerArmType()
    {
        const string rgName = "rg-ardl-abcdef0123456789";
        var result = OutputNormalizer.Normalize($"rg={rgName}", "sub", "tenant", rgName, "Microsoft.Storage/storageAccounts");

        var expectedPlaceholder = Provisioning.DeterministicNaming.PlaceholderResourceGroupName("Microsoft.Storage/storageAccounts");
        Assert.Contains(expectedPlaceholder, result);
    }

    [Fact]
    public void NormalizePortalFields_RedactsDirectoryAndSubscriptionDisplayNames()
    {
        // Live-observed leak (2026-08-13): a real capture surfaced the actual AAD tenant name under
        // "Directory Name" — the Essentials panel's own GUID fields (Subscription ID, Directory ID)
        // are caught by Normalize()'s substring replacement, but these two display-name fields aren't
        // the ID string, so they need their own label-targeted redaction.
        var fields = new List<PortalField>
        {
            new("Directory Name", "faketenantname"),
            new("Subscription", "My Real Company Subscription"),
            new("Location", "Norway East"),
        };

        var result = OutputNormalizer.NormalizePortalFields(fields);

        Assert.Equal(OutputNormalizer.PlaceholderDirectoryName, result.Single(f => f.Label == "Directory Name").Value);
        Assert.Equal(OutputNormalizer.PlaceholderSubscriptionName, result.Single(f => f.Label == "Subscription").Value);
        Assert.Equal("Norway East", result.Single(f => f.Label == "Location").Value);
    }
}
