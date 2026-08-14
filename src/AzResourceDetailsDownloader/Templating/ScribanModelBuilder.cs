using System.Text.Json;
using Scriban.Runtime;

namespace AzResourceDetailsDownloader.Templating;

// Builds the Scriban `model` object a generated template renders against — reusing JsonTree's
// navigation and SkuAndVersion's sku_label/version derivation (both dependency-free), adding only
// the ScriptObject/ScriptArray tree conversion that requires the Scriban package itself. Kept
// separate from those two so the recipe resolver (which never needs to render anything, only to
// decide where a value comes from) stays free of a templating-engine dependency.
public static class ScribanModelBuilder
{
    public static object? JsonToScriban(JsonElement elem) => elem.ValueKind switch
    {
        JsonValueKind.Object => JsonObjectToScriptObject(elem),
        JsonValueKind.Array => JsonArrayToScriptArray(elem),
        JsonValueKind.String => elem.GetString(),
        JsonValueKind.Number => elem.TryGetInt64(out var l) ? (object)l : elem.GetDouble(),
        JsonValueKind.True => true,
        JsonValueKind.False => false,
        _ => null,
    };

    private static ScriptObject JsonObjectToScriptObject(JsonElement obj)
    {
        var so = new ScriptObject();
        foreach (var prop in obj.EnumerateObject())
        {
            so[prop.Name.ToLowerInvariant()] = JsonToScriban(prop.Value);
        }
        return so;
    }

    private static ScriptArray JsonArrayToScriptArray(JsonElement arr)
    {
        var sa = new ScriptArray();
        foreach (var item in arr.EnumerateArray())
        {
            sa.Add(JsonToScriban(item));
        }
        return sa;
    }

    private static readonly System.Text.RegularExpressions.Regex ResourceGroupFromId =
        new(@"/resourceGroups/([^/]+)/", System.Text.RegularExpressions.RegexOptions.IgnoreCase);

    // Mirrors FieldRecipeResolver's ShortcutLabels handling — same fields, same derivation, so a
    // rendered preview and the recipe catalog's verification can never quietly disagree about what
    // model.location/model.resource_group actually contain.
    public static ScriptObject BuildModel(JsonElement root, string armType)
    {
        var propsElement = JsonTree.Navigate(root, "properties");
        var id = JsonTree.GetString(root, "id");
        var rgMatch = id is null ? null : ResourceGroupFromId.Match(id);

        var m = new ScriptObject
        {
            ["id"] = id,
            ["name"] = JsonTree.GetString(root, "name"),
            ["type"] = armType,
            ["location"] = JsonTree.GetString(root, "location"),
            ["resource_group"] = rgMatch is { Success: true } ? rgMatch.Groups[1].Value : null,
            ["tags"] = JsonTree.Navigate(root, "tags") is { } t ? JsonToScriban(t) : new ScriptObject(),
            ["props"] = propsElement is { } p ? JsonToScriban(p) : new ScriptObject(),
            ["sku_label"] = SkuAndVersion.SkuLabel(root),
            ["version"] = propsElement is { } p2 ? SkuAndVersion.ExtractVersion(armType, p2) : null,
            ["storage_replication_label"] = PortalFriendlyLabels.StorageReplicationLabel(root),
            ["storage_account_kind_label"] = PortalFriendlyLabels.StorageAccountKindLabel(root),
            ["disk_storage_type_label"] = PortalFriendlyLabels.DiskStorageTypeLabel(root),
            ["disk_security_type_label"] = PortalFriendlyLabels.DiskSecurityTypeLabel(root),
            ["mongo_cluster_tier_label"] = PortalFriendlyLabels.MongoClusterTierLabel(root),
            ["mongo_connectivity_method_label"] = PortalFriendlyLabels.MongoConnectivityMethodLabel(root),
            ["mongo_authentication_label"] = PortalFriendlyLabels.MongoAuthenticationLabel(root),
            ["mongo_storage_encryption_label"] = PortalFriendlyLabels.MongoStorageEncryptionLabel(root),
            ["logic_workflow_definition_label"] = PortalFriendlyLabels.LogicWorkflowDefinitionLabel(root),
            ["logic_integration_account_label"] = PortalFriendlyLabels.LogicIntegrationAccountLabel(root),
            ["logic_workflow_type_label"] = PortalFriendlyLabels.LogicWorkflowTypeLabel(root),
            ["appconfig_telemetry_label"] = PortalFriendlyLabels.AppConfigTelemetryLabel(root),
            ["aks_power_state_label"] = PortalFriendlyLabels.AksPowerStateLabel(root),
            ["aks_cluster_operation_status_label"] = PortalFriendlyLabels.AksClusterOperationStatusLabel(root),
            ["aks_api_server_address_label"] = PortalFriendlyLabels.AksApiServerAddressLabel(root),
            ["aks_node_pools_label"] = PortalFriendlyLabels.AksNodePoolsLabel(root),
            ["aks_network_configuration_label"] = PortalFriendlyLabels.AksNetworkConfigurationLabel(root),
        };
        return m;
    }
}
