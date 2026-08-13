using System.Text.RegularExpressions;

namespace AzResourceDetailsDownloader.Provisioning;

// Azure's well-documented "this subscription has never used this resource provider" error (README's own
// "Resource-provider registration" known limitation, previously a manual `az provider register` step) — safe
// and free to auto-fix by registering the provider and retrying once, the same shape of problem
// QuotaErrorDetector/SoftDeletePurger already handle for their own one-time/transient conditions.
//
// Two distinct wordings are recognized, both live-observed: the standard ARM PUT error
// ("MissingSubscriptionRegistration" / "not registered to use namespace 'X'", e.g. Microsoft.Maps) and the
// separate shape Microsoft.AzureTerraform's exportTerraform action returns ("RPNotRegistered" / "make sure
// the resource provider 'X' is registered") — different code path (IacExportService's direct ARM REST call,
// not ArmResourceProvisioner), same underlying condition, so both get the same one-time auto-fix.
public static partial class ResourceProviderRegistrationErrorDetector
{
    public static bool TryGetUnregisteredNamespace(string? message, out string namespaceName)
    {
        namespaceName = "";
        if (message is null)
        {
            return false;
        }

        if (message.Contains("MissingSubscriptionRegistration", StringComparison.Ordinal))
        {
            var match = NamespaceInMessagePattern().Match(message);
            if (match.Success)
            {
                namespaceName = match.Groups["ns"].Value;
                return true;
            }
        }

        if (message.Contains("RPNotRegistered", StringComparison.Ordinal))
        {
            var match = RpNotRegisteredNamespacePattern().Match(message);
            if (match.Success)
            {
                namespaceName = match.Groups["ns"].Value;
                return true;
            }
        }

        return false;
    }

    // Live-observed exact wording: "The subscription is not registered to use namespace 'Microsoft.Maps'."
    [GeneratedRegex(@"not registered to use namespace '(?<ns>[^']+)'")]
    private static partial Regex NamespaceInMessagePattern();

    // Live-observed exact wording: "make sure the resource provider 'Microsoft.AzureTerraform' is registered
    // on the subscription."
    [GeneratedRegex(@"resource provider '(?<ns>[^']+)' is registered")]
    private static partial Regex RpNotRegisteredNamespacePattern();
}
