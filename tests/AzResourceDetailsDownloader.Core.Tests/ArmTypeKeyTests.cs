using AzResourceDetailsDownloader.Output;

namespace AzResourceDetailsDownloader.Tests;

public class ArmTypeKeyTests
{
    [Theory]
    [InlineData("Microsoft.Storage/storageAccounts", "microsoft_storage_storageaccounts")]
    [InlineData("Microsoft.Sql/servers/databases", "microsoft_sql_servers_databases")]
    [InlineData("Microsoft.Resources/resourceGroups", "microsoft_resources_resourcegroups")]
    public void From_LowercasesAndReplacesSeparators(string armType, string expected)
    {
        Assert.Equal(expected, ArmTypeKey.From(armType));
    }
}
