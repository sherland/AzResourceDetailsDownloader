using System.Security.Cryptography;
using System.Text;

namespace AzResourceDetailsDownloader.Provisioning;

// Resource/prerequisite names need to be reproducible across runs so committed output files (data.json,
// resource-group.bicep/.tf, and the resource name visible in portal.png) don't churn on every re-run just
// from randomness. Seeding Random from a stable hash of the target armType — rather than a real random
// seed — makes every {randN} token resolve to the same value every time for the same catalog entry, since
// the same sequence of ResolveRandomTokens/RandomAlnumWithSafeDashes calls happens in the same order every
// run (the catalog structure itself doesn't change between runs). string.GetHashCode() is NOT used here —
// .NET randomizes it per-process by design, so it would defeat the whole point.
public static class DeterministicNaming
{
    // Microsoft.KeyVault/vaults is exempt: this tenant's own Azure Policy ("Key vaults should have deletion
    // protection enabled") denies creating a vault without enablePurgeProtection — live-verified, including
    // a failed attempt to work around it by omitting the property. A purge-protected vault can never be
    // purged before its ~90-day scheduledPurgeDate, no matter what, so a fixed deterministic name would only
    // ever work once per ~90 days in this tenant. Keeping genuine per-run randomness for just this one type
    // (same as before this feature existed) is the only thing that actually works here.
    private static readonly HashSet<string> ExemptFromDeterminism = new(StringComparer.OrdinalIgnoreCase)
    {
        "Microsoft.KeyVault/vaults"
    };

    public static Random CreateSeededRandom(string armType) =>
        ExemptFromDeterminism.Contains(armType) ? new Random() : new(SeedFor(armType));

    private static int SeedFor(string armType)
    {
        var hash = SHA256.HashData(Encoding.UTF8.GetBytes(armType));
        return BitConverter.ToInt32(hash, 0);
    }

    // A fixed, deterministic-per-armType placeholder for the ephemeral resource group's name when writing
    // output files — the *actual* resource group created in Azure stays randomly-named (rg-ardl-{guid}) for
    // real provisioning, since a deterministic RG name would risk colliding with a previous run's
    // fire-and-forget (WaitUntil.Started, not waited-to-completion) deletion still finishing in the
    // background. Only the recorded, committed text gets normalized to this stable value.
    public static string PlaceholderResourceGroupName(string armType)
    {
        var hash = SHA256.HashData(Encoding.UTF8.GetBytes(armType));
        return "rg-ardl-" + Convert.ToHexStringLower(hash)[..16];
    }
}
