using AzResourceDetailsDownloader.Provisioning;

namespace AzResourceDetailsDownloader.Tests;

public class TemplateTokenResolverTests
{
    [Fact]
    public void FindPrereqAliasReferences_ReturnsDistinctAliases()
    {
        const string text = "{prereq.sqlServer.name}/db-{prereq.sqlServer.id}-{prereq.vnet.name}";

        var aliases = TemplateTokenResolver.FindPrereqAliasReferences(text).ToList();

        Assert.Equal(["sqlServer", "vnet"], aliases);
    }

    [Fact]
    public void FindPrereqAliasReferences_ReturnsEmpty_WhenNoTokensPresent()
    {
        Assert.Empty(TemplateTokenResolver.FindPrereqAliasReferences("plain-name"));
    }

    [Fact]
    public void ResolvePrereqTokens_SubstitutesIdAndName()
    {
        var resolved = new Dictionary<string, ProvisionedResourceRef>
        {
            ["sqlServer"] = new ProvisionedResourceRef("/subscriptions/x/.../sql1", "sql1", "westeurope")
        };

        var result = TemplateTokenResolver.ResolvePrereqTokens("{prereq.sqlServer.name}/db1", resolved);

        Assert.Equal("sql1/db1", result);
    }

    [Fact]
    public void ResolvePrereqTokens_SubstitutesLocation()
    {
        var resolved = new Dictionary<string, ProvisionedResourceRef>
        {
            ["containerAppsEnv"] = new ProvisionedResourceRef("/subscriptions/x/.../cae1", "cae1", "swedencentral")
        };

        var result = TemplateTokenResolver.ResolvePrereqTokens("{prereq.containerAppsEnv.location}", resolved);

        Assert.Equal("swedencentral", result);
    }

    [Fact]
    public void ResolvePrereqTokens_Throws_WhenAliasUnresolved()
    {
        var resolved = new Dictionary<string, ProvisionedResourceRef>();

        Assert.Throws<InvalidOperationException>(() =>
            TemplateTokenResolver.ResolvePrereqTokens("{prereq.missing.name}", resolved));
    }

    [Fact]
    public void ResolvePrereqTokens_SubstitutesKey_WhenResolved()
    {
        var resolved = new Dictionary<string, ProvisionedResourceRef>
        {
            ["hdiStorage"] = new ProvisionedResourceRef("/subscriptions/x/.../st1", "st1", "eastus2", "the-real-storage-key")
        };

        var result = TemplateTokenResolver.ResolvePrereqTokens("{prereq.hdiStorage.key}", resolved);

        Assert.Equal("the-real-storage-key", result);
    }

    [Fact]
    public void ResolvePrereqTokens_Throws_WhenKeyReferencedButNotResolved()
    {
        // Live-observed design constraint: {prereq.*.key} is only resolved for Storage Account
        // prerequisites (see ResourceTypePipeline) — referencing it on anything else, or before
        // ResourceTypePipeline's listKeys fetch has run, must fail loudly rather than silently
        // substitute an empty/null string into a request body.
        var resolved = new Dictionary<string, ProvisionedResourceRef>
        {
            ["hdiStorage"] = new ProvisionedResourceRef("/subscriptions/x/.../st1", "st1", "eastus2")
        };

        Assert.Throws<InvalidOperationException>(() =>
            TemplateTokenResolver.ResolvePrereqTokens("{prereq.hdiStorage.key}", resolved));
    }

    [Fact]
    public void ReferencesPrereqKey_TrueOnlyForMatchingAliasAndKeyField()
    {
        Assert.True(TemplateTokenResolver.ReferencesPrereqKey("\"key\": \"{prereq.hdiStorage.key}\"", "hdiStorage"));
        Assert.False(TemplateTokenResolver.ReferencesPrereqKey("\"key\": \"{prereq.hdiStorage.name}\"", "hdiStorage"));
        Assert.False(TemplateTokenResolver.ReferencesPrereqKey("\"key\": \"{prereq.otherAlias.key}\"", "hdiStorage"));
    }

    [Fact]
    public void ResolveRandomTokens_ProducesRequestedLength_AndRespectsCharset()
    {
        var random = new Random(42);

        var result = TemplateTokenResolver.ResolveRandomTokens("st{rand8}", "lowerAlnum", random);

        Assert.Equal("st", result[..2]);
        Assert.Equal(10, result.Length);
        Assert.All(result[2..], c => Assert.True(char.IsLower(c) || char.IsDigit(c)));
    }
}
