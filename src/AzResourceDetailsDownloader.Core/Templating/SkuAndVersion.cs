using System.Text.Json;

namespace AzResourceDetailsDownloader.Templating;

// Independent reimplementation of the two composite-field conventions ("SKU label" and "version")
// that a downstream Obsidian/Scriban-style renderer would compute once and expose as a first-class
// shortcut rather than a raw property path — written fresh from ARM's own documented shapes, not
// copied from or dependent on any other tool's source. Only covers the resource types ARDL's own
// corpus currently needs; extend ExtractVersion's switch as more types are added.
public static class SkuAndVersion
{
    // "Tier (Name)" or just "Name" — prefers a root-level "sku" (the shape a raw ARM GET response
    // exposes at the root, sibling to "properties"), falls back to a properties-nested sku (Key
    // Vault, App Gateway, and others nest it instead).
    //
    // Known limitation, not yet corrected here: this reproduces the raw ARM casing verbatim (e.g.
    // Key Vault's sku.name is literally "standard", lowercase) — the portal title-cases it
    // ("Standard"). A caller that wants exact portal-text fidelity needs to title-case the result
    // itself; this function intentionally doesn't guess at a general-purpose title-casing rule.
    public static string? SkuLabel(JsonElement root)
    {
        var sku = JsonTree.Navigate(root, "sku") ?? JsonTree.Navigate(root, "properties", "sku");
        if (sku is not { ValueKind: JsonValueKind.Object } skuObj)
        {
            return null;
        }

        var name = JsonTree.GetString(skuObj, "name");
        var tier = JsonTree.GetString(skuObj, "tier");
        if (name is null && tier is null)
        {
            return null;
        }
        // Symmetric with the "tier is null" branch below — a sku object with only a tier and no
        // name shouldn't fall through to the combined format and produce "Tier ()" (found live
        // testing SkuAndVersionTests: string interpolation of a null `name` silently renders as
        // empty rather than throwing, so this went unnoticed until a test asserted the actual text).
        if (name is null)
        {
            return tier;
        }
        if (name == tier || tier is null)
        {
            return name;
        }
        return $"{tier} ({name})";
    }

    // Bare `sku.name`/`sku.tier`, same root/properties.sku lookup as SkuLabel above — some types
    // (AKS confirmed live 2026-08-14: "Sku" = sku.name = "Base", "Pricing tier" = sku.tier = "Free",
    // two separate Essentials fields) render these as plain direct passthroughs instead of ever
    // combining them into SkuLabel's "Tier (Name)" shape, so a caller needs both forms available to
    // match whichever one a given type actually uses.
    private static JsonElement? SkuObject(JsonElement root) =>
        JsonTree.Navigate(root, "sku") ?? JsonTree.Navigate(root, "properties", "sku");

    public static string? SkuName(JsonElement root) =>
        SkuObject(root) is { } sku ? JsonTree.GetString(sku, "name") : null;

    public static string? SkuTier(JsonElement root) =>
        SkuObject(root) is { } sku ? JsonTree.GetString(sku, "tier") : null;

    public static string? ExtractVersion(string armType, JsonElement properties)
    {
        string? Prop(params string[] path) => JsonTree.GetString(properties, path);
        string? First(params string?[] vals) => vals.FirstOrDefault(v => v is { Length: > 0 });

        return armType.ToLowerInvariant() switch
        {
            "microsoft.containerservice/managedclusters" => Prop("kubernetesVersion"),
            "microsoft.compute/virtualmachines/extensions" or "microsoft.hybridcompute/machines/extensions"
                => Prop("typeHandlerVersion"),
            "microsoft.web/sites" or "microsoft.web/sites/slots" => First(
                Prop("siteConfig", "linuxFxVersion"),
                Prop("siteConfig", "windowsFxVersion"),
                Prop("siteConfig", "netFrameworkVersion"),
                Prop("siteConfig", "javaVersion"),
                Prop("siteConfig", "phpVersion"),
                Prop("siteConfig", "nodeVersion"),
                Prop("siteConfig", "pythonVersion"),
                Prop("siteConfig", "currentStack")),
            "microsoft.sql/servers/databases" => First(
                Prop("requestedServiceObjectiveName"), Prop("currentServiceObjectiveName")),
            "microsoft.dbforpostgresql/flexibleservers" or "microsoft.dbforpostgresql/servers"
            or "microsoft.dbformysql/flexibleservers" or "microsoft.dbformysql/servers"
            or "microsoft.dbformariadb/servers" => Prop("version"),
            "microsoft.servicefabric/clusters" => Prop("clusterCodeVersion"),
            "microsoft.automation/automationaccounts/runbooks" => Prop("runbookType"),
            "microsoft.devtestlab/labs/virtualmachines" => First(
                Prop("galleryImageReference", "sku"), Prop("galleryImageReference", "offer")),
            _ => Prop("version"),
        };
    }
}
