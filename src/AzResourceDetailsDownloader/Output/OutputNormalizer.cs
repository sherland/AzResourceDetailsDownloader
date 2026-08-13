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
    // Live-observed leak (2026-08-13, Microsoft.Synapse/workspaces): "SQL Microsoft Entra admin"
    // defaults to whichever AAD identity created the resource — surfaced the operator's real,
    // personal email address. Matched by substring rather than an exact label, since other SQL/DB
    // types show the same concept under a slightly different label (e.g. plain "Microsoft Entra
    // admin" on Microsoft.Sql/servers itself) — better to over-redact than repeat this leak under
    // a label variant this list doesn't happen to have verbatim.
    public const string PlaceholderEntraAdmin = "admin@example.com";

    // Same leak as PlaceholderEntraAdmin, but in data.json/bicep/tf rather than portal-fields.json:
    // ARM auto-stamps the signed-in user's UPN into every resource's systemData.createdBy/
    // lastModifiedBy. Reuses the Entra-admin placeholder so both artifacts show the same
    // recognizably-fake identity rather than two different placeholder strings for the same kind
    // of redacted value.
    public const string PlaceholderUserPrincipalName = PlaceholderEntraAdmin;

    public static string Normalize(
        string text, string subscriptionId, string tenantId, string actualRgName, string armType,
        string? userPrincipalName = null)
    {
        var placeholderRgName = DeterministicNaming.PlaceholderResourceGroupName(armType);

        text = ReplaceCaseInsensitive(text, actualRgName, placeholderRgName);
        text = ReplaceCaseInsensitive(text, subscriptionId, PlaceholderSubscriptionId);
        text = ReplaceCaseInsensitive(text, tenantId, PlaceholderTenantId);
        if (!string.IsNullOrEmpty(userPrincipalName))
        {
            text = ReplaceCaseInsensitive(text, userPrincipalName, PlaceholderUserPrincipalName);
        }
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
            var label when label.Contains("Entra admin", StringComparison.OrdinalIgnoreCase)
                => f with { Value = PlaceholderEntraAdmin },
            _ => f,
        }).ToList();

    // newValue is a fixed placeholder (hex digits and dashes only), so it needs no regex-replacement escaping.
    private static string ReplaceCaseInsensitive(string text, string oldValue, string newValue) =>
        Regex.Replace(text, Regex.Escape(oldValue), newValue, RegexOptions.IgnoreCase);
}
