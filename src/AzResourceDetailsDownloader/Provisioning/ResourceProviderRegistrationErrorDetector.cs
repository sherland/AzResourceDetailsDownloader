using System.Text.RegularExpressions;

namespace AzResourceDetailsDownloader.Provisioning;

// Azure's well-documented "this subscription has never used this resource provider" error (README's own
// "Resource-provider registration" known limitation, previously a manual `az provider register` step) — safe
// and free to auto-fix by registering the provider and retrying once, the same shape of problem
// QuotaErrorDetector/SoftDeletePurger already handle for their own one-time/transient conditions.
public static partial class ResourceProviderRegistrationErrorDetector
{
    public static bool TryGetUnregisteredNamespace(string? message, out string namespaceName)
    {
        namespaceName = "";
        if (message is null || !message.Contains("MissingSubscriptionRegistration", StringComparison.Ordinal))
        {
            return false;
        }

        var match = NamespaceInMessagePattern().Match(message);
        if (!match.Success)
        {
            return false;
        }

        namespaceName = match.Groups["ns"].Value;
        return true;
    }

    // Live-observed exact wording: "The subscription is not registered to use namespace 'Microsoft.Maps'."
    [GeneratedRegex(@"not registered to use namespace '(?<ns>[^']+)'")]
    private static partial Regex NamespaceInMessagePattern();
}
