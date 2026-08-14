using System.Text.Json;

namespace AzResourceDetailsDownloader.Templating;

// Friendly-text lookup tables for the handful of fields where the Azure Portal runs a raw ARM enum
// through a translation table before displaying it — every entry here was read directly out of the
// live portal's own already-loaded JS (2026-08-14), not guessed, the same "live-verified, never
// guessed" bar as config/azure-locations.json (see FieldRecipeResolver's four Resolve*Shortcut
// methods that reference this class for the full provenance comment and the two-step
// fiber-walk-then-module-search technique that found them).
//
// Shared between FieldRecipeResolver (which only needs to decide where a value comes from) and
// ScribanModelBuilder (which needs to actually compute it for a rendered preview) for the same
// reason SkuAndVersion is: a rendered preview and the recipe catalog's verification must never
// quietly disagree about what model.storage_replication_label etc. actually contain.
public static class PortalFriendlyLabels
{
    private static readonly Dictionary<string, string> StorageReplicationCategoryBySkuName =
        new(StringComparer.OrdinalIgnoreCase)
        {
            ["Premium_LRS"] = "lrs", ["PremiumV2_LRS"] = "lrs", ["Standard_LRS"] = "lrs", ["StandardV2_LRS"] = "lrs",
            ["Standard_GRS"] = "grs", ["StandardV2_GRS"] = "grs",
            ["Standard_RAGRS"] = "ragrs",
            ["Premium_ZRS"] = "zrs", ["PremiumV2_ZRS"] = "zrs",
            ["Standard_ZRS"] = "zrs*", ["StandardV2_ZRS"] = "zrs*", // '*' = resolved against `kind` below
            ["Standard_GZRS"] = "gzrs", ["StandardV2_GZRS"] = "gzrs",
            ["Standard_RAGZRS"] = "ragzrs",
        };

    private static readonly Dictionary<string, string> StorageReplicationText =
        new(StringComparer.OrdinalIgnoreCase)
        {
            ["lrs"] = "Locally redundant storage (LRS)",
            ["grs"] = "Geo-redundant storage (GRS)",
            ["ragrs"] = "Read-access geo-redundant storage (RA-GRS)",
            ["zrs"] = "Zone-redundant storage (ZRS)",
            ["zrsClassic"] = "Zone-redundant storage (ZRS classic)",
            ["gzrs"] = "Geo-zone-redundant storage (GZRS)",
            ["ragzrs"] = "Read-access geo-zone-redundant storage (RA-GZRS)",
        };

    // Storage Accounts: `Ve(sku.name, kind === "Storage")`. Returns null when sku.name isn't in the
    // known table (a new/unseen SKU, or no sku.name at all) — callers decide how to treat that.
    public static string? StorageReplicationLabel(JsonElement root)
    {
        var skuName = JsonTree.GetString(root, "sku", "name");
        if (skuName is null || !StorageReplicationCategoryBySkuName.TryGetValue(skuName, out var category))
        {
            return null;
        }
        if (category == "zrs*")
        {
            var kind = JsonTree.GetString(root, "kind");
            category = string.Equals(kind, "Storage", StringComparison.OrdinalIgnoreCase) ? "zrsClassic" : "zrs";
        }
        return StorageReplicationText[category];
    }

    private static readonly Dictionary<string, string> StorageAccountKindFormat =
        new(StringComparer.OrdinalIgnoreCase)
        {
            ["Storage"] = "{0} (general purpose v1)",
            ["StorageV2"] = "{0} (general purpose v2)",
        };

    // Storage Accounts: `Le(kind, id)`. Doesn't replicate the classic-storage-account-ID branch
    // (always renders "{kind} (classic)" for a pre-ARM ID shape) — no capture this tool takes ever
    // has one, so it's not worth the complexity of reproducing.
    public static string? StorageAccountKindLabel(JsonElement root)
    {
        var kind = JsonTree.GetString(root, "kind");
        if (kind is null)
        {
            return null;
        }
        return StorageAccountKindFormat.TryGetValue(kind, out var format) ? string.Format(format, kind) : kind;
    }

    private static readonly Dictionary<string, string> DiskStorageTypeText =
        new(StringComparer.OrdinalIgnoreCase)
        {
            ["Standard_LRS"] = "Standard HDD LRS",
            ["StandardSSD_LRS"] = "Standard SSD LRS",
            ["StandardSSD_ZRS"] = "Standard SSD ZRS",
            ["UltraSSD_LRS"] = "Ultra disk LRS",
            ["Premium_LRS"] = "Premium SSD LRS",
            ["Premium_ZRS"] = "Premium SSD ZRS",
            ["PremiumV2_LRS"] = "Premium SSD v2 LRS",
            ["Standard_ZRS"] = "Zone-redundant",
        };

    // Compute/disks (and snapshots, same shape): `Hs(sku.name)`.
    public static string? DiskStorageTypeLabel(JsonElement root)
    {
        var skuName = JsonTree.GetString(root, "sku", "name");
        return skuName is not null && DiskStorageTypeText.TryGetValue(skuName, out var text) ? text : null;
    }

    private static readonly Dictionary<string, string> DiskSecurityTypeText =
        new(StringComparer.OrdinalIgnoreCase)
        {
            ["Standard"] = "Standard",
            ["TrustedLaunch"] = "Trusted launch",
            ["TrustedLaunchSupported"] = "Trusted launch supported",
            ["ConfidentialVM_VMGuestStateOnlyEncryptedWithPlatformKey"] = "Confidential",
            ["ConfidentialVM_DiskEncryptedWithPlatformKey"] = "Confidential",
            ["ConfidentialVM_DiskEncryptedWithCustomerKey"] = "Confidential",
        };

    // Compute/disks: `st(properties.securityProfile.securityType)` — a disk with no securityProfile
    // at all falls back to "Standard" in the portal's own code, reproduced here rather than null.
    public static string DiskSecurityTypeLabel(JsonElement root)
    {
        var securityType = JsonTree.GetString(root, "properties", "securityProfile", "securityType");
        return securityType is not null && DiskSecurityTypeText.TryGetValue(securityType, out var text)
            ? text
            : "Standard";
    }
}
