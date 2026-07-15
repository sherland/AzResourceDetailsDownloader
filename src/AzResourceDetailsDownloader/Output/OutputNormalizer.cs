using System.Text.RegularExpressions;
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

    public static string Normalize(string text, string subscriptionId, string tenantId, string actualRgName, string armType)
    {
        var placeholderRgName = DeterministicNaming.PlaceholderResourceGroupName(armType);

        text = ReplaceCaseInsensitive(text, actualRgName, placeholderRgName);
        text = ReplaceCaseInsensitive(text, subscriptionId, PlaceholderSubscriptionId);
        text = ReplaceCaseInsensitive(text, tenantId, PlaceholderTenantId);
        return text;
    }

    // newValue is a fixed placeholder (hex digits and dashes only), so it needs no regex-replacement escaping.
    private static string ReplaceCaseInsensitive(string text, string oldValue, string newValue) =>
        Regex.Replace(text, Regex.Escape(oldValue), newValue, RegexOptions.IgnoreCase);
}
