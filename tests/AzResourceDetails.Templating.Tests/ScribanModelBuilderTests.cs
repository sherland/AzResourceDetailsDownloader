using System.Text.Json;

namespace AzResourceDetails.Templating.Tests;

// ScribanModelBuilder had no dedicated test file before this library was extracted — only indirect
// coverage through AzResourceDetailsDownloader.Core.Tests' FieldRecipeResolverTests/
// TemplateGeneratorTests, which exercise it as a side effect of testing something else. These are
// the library's own direct tests for the one public entry point, BuildModel.
public class ScribanModelBuilderTests
{
    private static JsonElement Parse(string json) => JsonDocument.Parse(json).RootElement;

    [Fact]
    public void BuildModel_PopulatesTheFirstClassFieldsFromRootLevelArmProperties()
    {
        var root = Parse("""
            {
              "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example/providers/Microsoft.Test/things/thing1",
              "name": "thing1",
              "location": "norwayeast",
              "tags": { "env": "test" },
              "properties": { "foo": "bar" }
            }
            """);

        var model = ScribanModelBuilder.BuildModel(root, "Microsoft.Test/things");

        Assert.Equal(root.GetProperty("id").GetString(), model["id"]);
        Assert.Equal("thing1", model["name"]);
        Assert.Equal("Microsoft.Test/things", model["type"]);
        Assert.Equal("norwayeast", model["location"]);
        Assert.Equal("rg-example", model["resource_group"]);
    }

    [Fact]
    public void BuildModel_Props_ExposesTheWholePropertiesTreeIncludingNestedArrays()
    {
        var root = Parse("""
            {
              "name": "thing1",
              "properties": { "items": [ { "count": 3 }, { "count": 5 } ], "nested": { "flag": true } }
            }
            """);

        var model = ScribanModelBuilder.BuildModel(root, "Microsoft.Test/things");
        var props = Assert.IsType<Scriban.Runtime.ScriptObject>(model["props"]);
        var items = Assert.IsType<Scriban.Runtime.ScriptArray>(props["items"]);
        var nested = Assert.IsType<Scriban.Runtime.ScriptObject>(props["nested"]);

        Assert.Equal(2, items.Count);
        Assert.Equal(true, nested["flag"]);
    }

    [Fact]
    public void BuildModel_NoTagsInSource_StillExposesAnEmptyTagsObject_NotNull()
    {
        var root = Parse("""{ "name": "thing1" }""");

        var model = ScribanModelBuilder.BuildModel(root, "Microsoft.Test/things");

        Assert.IsType<Scriban.Runtime.ScriptObject>(model["tags"]);
    }

    [Fact]
    public void BuildModel_SkuFields_MirrorSkuAndVersionExactly()
    {
        var root = Parse("""{ "name": "thing1", "sku": { "tier": "Standard", "name": "Standard_LRS", "capacity": 3 } }""");

        var model = ScribanModelBuilder.BuildModel(root, "Microsoft.Test/things");

        Assert.Equal("Standard (Standard_LRS)", model["sku_label"]);
        Assert.Equal("Standard_LRS", model["sku_name"]);
        Assert.Equal("Standard", model["sku_tier"]);
        Assert.Equal(3L, model["sku_capacity"]);
    }

    [Fact]
    public void BuildModel_NoSkuObjectAtAll_SkuFieldsAreNull()
    {
        var root = Parse("""{ "name": "thing1" }""");

        var model = ScribanModelBuilder.BuildModel(root, "Microsoft.Test/things");

        Assert.Null(model["sku_label"]);
        Assert.Null(model["sku_name"]);
        Assert.Null(model["sku_tier"]);
        Assert.Null(model["sku_capacity"]);
    }

    // Confirms the friendly-label fields actually reach ScribanModelBuilder's output (not just
    // PortalFriendlyLabels in isolation) — storage_replication_label is a representative example.
    [Fact]
    public void BuildModel_FriendlyLabelFields_AreComputedFromPortalFriendlyLabels()
    {
        var root = Parse("""{ "name": "thing1", "sku": { "name": "Standard_LRS" } }""");

        var model = ScribanModelBuilder.BuildModel(root, "Microsoft.Storage/storageAccounts");

        Assert.Equal("Locally redundant storage (LRS)", model["storage_replication_label"]);
    }
}
