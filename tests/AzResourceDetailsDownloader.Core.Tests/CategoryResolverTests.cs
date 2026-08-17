using AzResourceDetailsDownloader.Config;
using AzResourceDetailsDownloader.Output;

namespace AzResourceDetailsDownloader.Tests;

public class CategoryResolverTests
{
    private static ResourceAbbreviationsCatalog BuildCatalog(params (string Namespace, string Category)[] rows) =>
        new()
        {
            SourceUrl = "https://example.test",
            FetchedUtc = "2026-01-01T00:00:00Z",
            Entries = rows.Select(r => new AbbreviationEntry
            {
                Category = r.Category,
                Resource = r.Namespace,
                ResourceProviderNamespace = r.Namespace,
                Abbreviation = "x"
            }).ToList()
        };

    [Fact]
    public void ResolveCategory_ReturnsExactMatch()
    {
        var resolver = new CategoryResolver(BuildCatalog(("Microsoft.Storage/storageAccounts", "Storage")));

        Assert.Equal("Storage", resolver.ResolveCategory("Microsoft.Storage/storageAccounts"));
    }

    [Fact]
    public void ResolveCategory_FallsBackToParentType_OneLevel()
    {
        var resolver = new CategoryResolver(BuildCatalog(("Microsoft.Network/virtualNetworks", "Networking")));

        Assert.Equal("Networking", resolver.ResolveCategory("Microsoft.Network/virtualNetworks/subnets"));
    }

    [Fact]
    public void ResolveCategory_FallsBackToParentType_TwoLevels()
    {
        var resolver = new CategoryResolver(BuildCatalog(("Microsoft.Cache/redisEnterprise", "Databases")));

        // Synthetic 2-level-deep child, matching a real shape (Microsoft.Cache/redisEnterprise/databases)
        // one level down from the resolvable parent used here.
        Assert.Equal("Databases", resolver.ResolveCategory("Microsoft.Cache/redisEnterprise/databases/extra"));
    }

    [Fact]
    public void ResolveCategory_ReturnsUncategorized_WhenNoMatchAtAnyLevel()
    {
        var resolver = new CategoryResolver(BuildCatalog(("Microsoft.Storage/storageAccounts", "Storage")));

        Assert.Equal(CategoryResolver.Uncategorized, resolver.ResolveCategory("Microsoft.Something/notInTable"));
    }

    [Fact]
    public void ResolveCategory_ReturnsUncategorized_WhenCatalogIsNull()
    {
        var resolver = new CategoryResolver(null);

        Assert.Equal(CategoryResolver.Uncategorized, resolver.ResolveCategory("Microsoft.Storage/storageAccounts"));
    }

    [Fact]
    public void ResolveCategory_IsCaseInsensitive()
    {
        var resolver = new CategoryResolver(BuildCatalog(("Microsoft.Storage/storageAccounts", "Storage")));

        Assert.Equal("Storage", resolver.ResolveCategory("microsoft.storage/storageaccounts"));
    }

    [Fact]
    public void ResolveCategory_PrefersShorterResourceName_WhenSameNamespaceHasGenuinelyDifferentCategories()
    {
        // Live-verified real case: Microsoft.Storage/storageAccounts appears twice with no kind qualifier —
        // "VM storage account"/Compute and web and "Storage account"/Storage. The generic, shorter-named
        // entry should win regardless of which order the source table lists them in.
        var resolverGenericFirst = new CategoryResolver(new ResourceAbbreviationsCatalog
        {
            SourceUrl = "https://example.test",
            FetchedUtc = "2026-01-01T00:00:00Z",
            Entries =
            [
                new AbbreviationEntry { Category = "Storage", Resource = "Storage account", ResourceProviderNamespace = "Microsoft.Storage/storageAccounts", Abbreviation = "st" },
                new AbbreviationEntry { Category = "Compute and web", Resource = "VM storage account", ResourceProviderNamespace = "Microsoft.Storage/storageAccounts", Abbreviation = "stvm" }
            ]
        });
        var resolverSpecificFirst = new CategoryResolver(new ResourceAbbreviationsCatalog
        {
            SourceUrl = "https://example.test",
            FetchedUtc = "2026-01-01T00:00:00Z",
            Entries =
            [
                new AbbreviationEntry { Category = "Compute and web", Resource = "VM storage account", ResourceProviderNamespace = "Microsoft.Storage/storageAccounts", Abbreviation = "stvm" },
                new AbbreviationEntry { Category = "Storage", Resource = "Storage account", ResourceProviderNamespace = "Microsoft.Storage/storageAccounts", Abbreviation = "st" }
            ]
        });

        Assert.Equal("Storage", resolverGenericFirst.ResolveCategory("Microsoft.Storage/storageAccounts"));
        Assert.Equal("Storage", resolverSpecificFirst.ResolveCategory("Microsoft.Storage/storageAccounts"));
    }

    private static CategoryOverridesCatalog BuildOverrides(params (string ArmType, string Category)[] rows) =>
        new()
        {
            Overrides = rows.Select(r => new CategoryOverride
            {
                ArmType = r.ArmType,
                Category = r.Category,
                Reason = "test"
            }).ToList()
        };

    [Fact]
    public void ResolveCategory_UsesOverride_WhenAbbreviationsTableHasNoMatch()
    {
        var resolver = new CategoryResolver(
            BuildCatalog(("Microsoft.Storage/storageAccounts", "Storage")),
            BuildOverrides(("Microsoft.Portal/dashboards", "Management and governance")));

        Assert.Equal("Management and governance", resolver.ResolveCategory("Microsoft.Portal/dashboards"));
    }

    [Fact]
    public void ResolveCategory_PrefersAbbreviationsTableMatch_OverOverride()
    {
        var resolver = new CategoryResolver(
            BuildCatalog(("Microsoft.Storage/storageAccounts", "Storage")),
            BuildOverrides(("Microsoft.Storage/storageAccounts", "Compute and web")));

        Assert.Equal("Storage", resolver.ResolveCategory("Microsoft.Storage/storageAccounts"));
    }

    [Fact]
    public void ResolveCategory_ReturnsUncategorized_WhenNoOverrideAndNoAbbreviationsMatch()
    {
        var resolver = new CategoryResolver(
            BuildCatalog(("Microsoft.Storage/storageAccounts", "Storage")),
            BuildOverrides(("Microsoft.Portal/dashboards", "Management and governance")));

        Assert.Equal(CategoryResolver.Uncategorized, resolver.ResolveCategory("Microsoft.Something/notInTableOrOverrides"));
    }

    [Fact]
    public void ResolveCategory_FallsThroughToUncategorized_WhenOverridesCatalogIsNull()
    {
        var resolver = new CategoryResolver(BuildCatalog(("Microsoft.Storage/storageAccounts", "Storage")), null);

        Assert.Equal("Storage", resolver.ResolveCategory("Microsoft.Storage/storageAccounts"));
        Assert.Equal(CategoryResolver.Uncategorized, resolver.ResolveCategory("Microsoft.Portal/dashboards"));
    }
}
