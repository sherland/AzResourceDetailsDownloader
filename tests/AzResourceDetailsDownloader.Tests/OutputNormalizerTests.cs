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
}
