using AzResourceDetailsDownloader.Provisioning;

namespace AzResourceDetailsDownloader.Tests;

public class DeterministicNamingTests
{
    [Fact]
    public void CreateSeededRandom_ProducesSameSequence_ForSameArmType()
    {
        var first = DeterministicNaming.CreateSeededRandom("Microsoft.Storage/storageAccounts");
        var second = DeterministicNaming.CreateSeededRandom("Microsoft.Storage/storageAccounts");

        Assert.Equal(first.Next(), second.Next());
        Assert.Equal(first.Next(), second.Next());
    }

    [Fact]
    public void CreateSeededRandom_ProducesDifferentSequences_ForDifferentArmTypes()
    {
        var a = DeterministicNaming.CreateSeededRandom("Microsoft.Storage/storageAccounts");
        var b = DeterministicNaming.CreateSeededRandom("Microsoft.KeyVault/vaults");

        Assert.NotEqual(a.Next(), b.Next());
    }

    [Fact]
    public void PlaceholderResourceGroupName_IsStable_AndFollowsExpectedShape()
    {
        var name = DeterministicNaming.PlaceholderResourceGroupName("Microsoft.Storage/storageAccounts");

        Assert.Equal(name, DeterministicNaming.PlaceholderResourceGroupName("Microsoft.Storage/storageAccounts"));
        Assert.StartsWith("rg-ardl-", name);
        Assert.Equal(24, name.Length);
    }

    [Fact]
    public void PlaceholderResourceGroupName_Differs_AcrossArmTypes()
    {
        var a = DeterministicNaming.PlaceholderResourceGroupName("Microsoft.Storage/storageAccounts");
        var b = DeterministicNaming.PlaceholderResourceGroupName("Microsoft.KeyVault/vaults");

        Assert.NotEqual(a, b);
    }

    [Fact]
    public void CreateSeededRandom_WithPrefix_ProducesDifferentSequence_ThanUnprefixed()
    {
        // Guards against a naming collision like the one hit live: 'Microsoft.Storage/storageAccounts'
        // colliding with a name already reserved somewhere in Azure, since the unprefixed seed is purely
        // SHA256(armType) — a namePrefix must shift the whole sequence to dodge that.
        var unprefixed = DeterministicNaming.CreateSeededRandom("Microsoft.Storage/storageAccounts");
        var prefixed = DeterministicNaming.CreateSeededRandom("Microsoft.Storage/storageAccounts", "myteam");

        Assert.NotEqual(unprefixed.Next(), prefixed.Next());
    }

    [Fact]
    public void CreateSeededRandom_WithSamePrefix_IsStillDeterministic()
    {
        var first = DeterministicNaming.CreateSeededRandom("Microsoft.Storage/storageAccounts", "myteam");
        var second = DeterministicNaming.CreateSeededRandom("Microsoft.Storage/storageAccounts", "myteam");

        Assert.Equal(first.Next(), second.Next());
        Assert.Equal(first.Next(), second.Next());
    }

    [Fact]
    public void CreateSeededRandom_EmptyPrefix_MatchesNoPrefixOverload()
    {
        var noPrefixArg = DeterministicNaming.CreateSeededRandom("Microsoft.Storage/storageAccounts");
        var emptyPrefix = DeterministicNaming.CreateSeededRandom("Microsoft.Storage/storageAccounts", "");

        Assert.Equal(noPrefixArg.Next(), emptyPrefix.Next());
    }

    [Fact]
    public void CreateSeededRandom_IsGenuinelyRandom_ForKeyVault()
    {
        // Microsoft.KeyVault/vaults is exempt from deterministic naming — this tenant mandates
        // enablePurgeProtection, and a purge-protected vault can never be purged, so a fixed name would
        // only ever work once per ~90 days. Two calls should (with overwhelming probability) diverge.
        var first = DeterministicNaming.CreateSeededRandom("Microsoft.KeyVault/vaults");
        var second = DeterministicNaming.CreateSeededRandom("Microsoft.KeyVault/vaults");

        var firstSequence = new[] { first.Next(), first.Next(), first.Next() };
        var secondSequence = new[] { second.Next(), second.Next(), second.Next() };

        Assert.NotEqual(firstSequence, secondSequence);
    }
}
