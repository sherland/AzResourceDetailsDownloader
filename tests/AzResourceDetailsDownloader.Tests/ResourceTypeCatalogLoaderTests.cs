using AzResourceDetailsDownloader.Config;

namespace AzResourceDetailsDownloader.Tests;

public class ResourceTypeCatalogLoaderTests
{
    [Fact]
    public void Load_Throws_WhenFileMissing()
    {
        Assert.Throws<FileNotFoundException>(() =>
            ResourceTypeCatalogLoader.Load(Path.Combine(Path.GetTempPath(), Guid.NewGuid() + ".json")));
    }

    [Fact]
    public void Load_Throws_OnDuplicateArmType()
    {
        var path = WriteTempCatalog("""
            {
              "$schemaVersion": 1,
              "resourceTypes": [
                { "armType": "Microsoft.Storage/storageAccounts", "apiVersion": "2023-05-01", "costTier": "Free", "nameTemplate": "st{rand8}", "requestBody": {} },
                { "armType": "Microsoft.Storage/storageAccounts", "apiVersion": "2023-05-01", "costTier": "Free", "nameTemplate": "st{rand8}", "requestBody": {} }
              ]
            }
            """);

        var ex = Assert.Throws<InvalidOperationException>(() => ResourceTypeCatalogLoader.Load(path));
        Assert.Contains("Duplicate armType", ex.Message);
    }

    [Fact]
    public void Load_Throws_OnUndeclaredPrerequisiteAlias()
    {
        var path = WriteTempCatalog("""
            {
              "$schemaVersion": 1,
              "resourceTypes": [
                {
                  "armType": "Microsoft.Sql/servers/databases",
                  "apiVersion": "2023-08-01",
                  "costTier": "Low",
                  "nameTemplate": "{prereq.sqlServer.name}/db{rand6}",
                  "requestBody": {},
                  "prerequisites": []
                }
              ]
            }
            """);

        var ex = Assert.Throws<InvalidOperationException>(() => ResourceTypeCatalogLoader.Load(path));
        Assert.Contains("undeclared prerequisite alias", ex.Message);
    }

    [Fact]
    public void Load_Succeeds_ForValidCatalogWithPrerequisite()
    {
        var path = WriteTempCatalog("""
            {
              "$schemaVersion": 1,
              "resourceTypes": [
                {
                  "armType": "Microsoft.Sql/servers/databases",
                  "apiVersion": "2023-08-01",
                  "costTier": "Low",
                  "nameTemplate": "{prereq.sqlServer.name}/db{rand6}",
                  "requestBody": {},
                  "prerequisites": [
                    {
                      "alias": "sqlServer",
                      "armType": "Microsoft.Sql/servers",
                      "apiVersion": "2023-08-01",
                      "nameTemplate": "sql{rand8}",
                      "requestBody": {}
                    }
                  ]
                }
              ]
            }
            """);

        var catalog = ResourceTypeCatalogLoader.Load(path);

        Assert.Equal(1, catalog.SchemaVersion);
        var def = Assert.Single(catalog.ResourceTypes);
        Assert.Equal(CostTier.Low, def.CostTier);
        var prereq = Assert.Single(def.Prerequisites);
        Assert.Equal("sqlServer", prereq.Alias);
    }

    private static string WriteTempCatalog(string json)
    {
        var path = Path.Combine(Path.GetTempPath(), Guid.NewGuid() + ".json");
        File.WriteAllText(path, json);
        return path;
    }
}
