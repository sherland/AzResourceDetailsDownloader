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

    // model.tags is deliberately NOT part of the shared model (see PopulateSharedFields' doc
    // comment) — no generated template references it, and the two known consumers of this library
    // want different shapes for it. A host that wants a tags field populates it itself, before or
    // after calling PopulateSharedFields.
    [Fact]
    public void BuildModel_NeverPopulatesTags_HostOwnsThatFieldEntirely()
    {
        var root = Parse("""{ "name": "thing1", "tags": { "env": "test" } }""");

        var model = ScribanModelBuilder.BuildModel(root, "Microsoft.Test/things");

        Assert.False(model.ContainsKey("tags"));
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

    // The equivalence guarantee a decomposed-input consumer (e.g. AzToMd's TenantNode) depends on:
    // building from a full ARM document and building from that SAME document's manually-decomposed
    // TemplateResource must produce identical values for every field this library declares shared.
    // Exercises id/name/location/resource_group (from the id), kind + sku (StorageReplicationLabel
    // needs both), and identity.type (MongoStorageEncryptionLabel) — the two root-level fields most
    // at risk of being missed by a hand-rolled decomposition, since they sit outside properties/sku.
    [Fact]
    public void BuildModel_JsonElementOverload_AndTemplateResourceOverload_ProduceTheSameSharedFields()
    {
        var root = Parse("""
            {
              "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example/providers/Microsoft.Storage/storageAccounts/thing1",
              "name": "thing1",
              "location": "norwayeast",
              "kind": "StorageV2",
              "identity": { "type": "UserAssigned" },
              "sku": { "name": "Standard_GRS", "tier": "Standard", "capacity": 1 },
              "properties": { "foo": "bar" }
            }
            """);
        const string armType = "Microsoft.Storage/storageAccounts";

        var fromJson = ScribanModelBuilder.BuildModel(root, armType);

        var resource = new TemplateResource(
            Id: root.GetProperty("id").GetString(),
            Name: "thing1",
            ArmType: armType,
            Location: "norwayeast",
            ResourceGroup: "rg-example",
            Kind: "StorageV2",
            IdentityType: "UserAssigned",
            Properties: root.GetProperty("properties"),
            Sku: root.GetProperty("sku"));
        var fromResource = ScribanModelBuilder.BuildModel(resource);

        foreach (var field in TemplateRuntimeContract.SupportedModelFields)
        {
            Assert.Equal(fromJson[field], fromResource[field]);
        }
    }

    // PopulateSharedFields must never clobber fields the host already added — this is the whole
    // point of exposing it separately from BuildModel, so a host can populate its own vault-specific
    // fields into the same ScriptObject before/after calling this.
    [Fact]
    public void PopulateSharedFields_LeavesPreExistingHostOwnedKeysUntouched()
    {
        var target = new Scriban.Runtime.ScriptObject { ["wiki_links"] = "some-host-specific-value" };
        var resource = new TemplateResource(
            Id: null, Name: "thing1", ArmType: "Microsoft.Test/things", Location: null, ResourceGroup: null,
            Kind: null, IdentityType: null, Properties: default, Sku: default);

        ScribanModelBuilder.PopulateSharedFields(target, resource);

        Assert.Equal("some-host-specific-value", target["wiki_links"]);
        Assert.Equal("thing1", target["name"]);
    }
}
