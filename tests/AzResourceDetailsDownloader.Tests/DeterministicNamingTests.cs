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
