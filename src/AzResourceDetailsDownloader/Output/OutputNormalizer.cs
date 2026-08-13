using System.Text.RegularExpressions;
using AzResourceDetailsDownloader.Capture;
using AzResourceDetailsDownloader.Provisioning;

namespace AzResourceDetailsDownloader.Output;

// Subscription ID, tenant ID, and the ephemeral resource group's actual (randomly-generated) name all vary
// per run and show up throughout data.json/resource-group.bicep/resource-group.tf — normalizing them to
// fixed placeholders is what makes those text files diff-stable across re-runs and across whoever runs the
// tool, on top of the deterministic resource naming in DeterministicNaming. The screenshot can't be
// normalized this way (it's a rendered image, not text) and will always show the real subscription ID.
public static class OutputNormalizer
{
    // Deliberately distinct (not both all-zeros) so subscription vs. tenant is obvious at a glance in
    // committed files, per explicit request.
    public const string PlaceholderSubscriptionId = "00000000-0000-0000-0000-000000000000";
    public const string PlaceholderTenantId = "11111111-1111-1111-1111-111111111111";

    // The Overview blade's Essentials panel shows human-readable names alongside the GUIDs above —
    // "Directory Name" (the AAD tenant's display name) and "Subscription" (its display name) are
    // identifying text that the GUID-based replacement above can't catch (they're not the tenant/sub
    // ID string). Live-observed leak: a real capture surfaced "Directory Name": "<the tenant owner's
    // actual AAD tenant name>" uncaught by Normalize() below, since portal-fields.json is the only
    // artifact that ever contains these display names — data.json/bicep/tf don't.
    public const string PlaceholderDirectoryName = "example-tenant";
    public const string PlaceholderSubscriptionName = "Example Subscription";

    public static string Normalize(string text, string subscriptionId, string tenantId, string actualRgName, string armType)
    {
        var placeholderRgName = DeterministicNaming.PlaceholderResourceGroupName(armType);

        text = ReplaceCaseInsensitive(text, actualRgName, placeholderRgName);
        text = ReplaceCaseInsensitive(text, subscriptionId, PlaceholderSubscriptionId);
        text = ReplaceCaseInsensitive(text, tenantId, PlaceholderTenantId);
        return text;
    }

    // Essentials fields need the GUID/RG-name substitution above (for "Subscription ID", "Directory
    // ID", "Resource group") plus label-targeted redaction for the human-readable names that
    // Normalize()'s substring replacement can't catch on its own.
    public static IReadOnlyList<PortalField> NormalizePortalFields(IReadOnlyList<PortalField> fields) =>
        fields.Select(f => f.Label switch
        {
            "Directory Name" => f with { Value = PlaceholderDirectoryName },
            "Subscription" => f with { Value = PlaceholderSubscriptionName },
            _ => f,
        }).ToList();

    // newValue is a fixed placeholder (hex digits and dashes only), so it needs no regex-replacement escaping.
    private static string ReplaceCaseInsensitive(string text, string oldValue, string newValue) =>
        Regex.Replace(text, Regex.Escape(oldValue), newValue, RegexOptions.IgnoreCase);
}
