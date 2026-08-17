using System.Text.Json;
using AzResourceDetailsDownloader.Reporting;

namespace AzResourceDetailsDownloader.Tests;

public sealed class RunSummaryTests : IDisposable
{
    private readonly string _outputRoot = Path.Combine(Path.GetTempPath(), "ardl-run-summary-tests-" + Guid.NewGuid());

    public void Dispose()
    {
        if (Directory.Exists(_outputRoot))
        {
            Directory.Delete(_outputRoot, recursive: true);
        }
    }

    [Fact]
    public void Add_AppendsToResults()
    {
        var summary = new RunSummary();

        summary.Add(new RunResult("Microsoft.KeyVault/vaults", true, TimeSpan.FromSeconds(1), null));
        summary.Add(new RunResult("Microsoft.Storage/storageAccounts", false, TimeSpan.FromSeconds(2), "boom"));

        Assert.Equal(2, summary.Results.Count);
    }

    // Used by the quota-error retry pass — a unit that failed in the main run and is retried
    // afterward replaces its original entry, not a second one for the same ArmType.
    [Fact]
    public void ReplaceOrAdd_ExistingArmType_ReplacesRatherThanDuplicates()
    {
        var summary = new RunSummary();
        summary.Add(new RunResult("Microsoft.KeyVault/vaults", false, TimeSpan.FromSeconds(1), "QuotaExceeded"));

        summary.ReplaceOrAdd(new RunResult("Microsoft.KeyVault/vaults", true, TimeSpan.FromSeconds(3), null));

        var result = Assert.Single(summary.Results);
        Assert.True(result.Success);
        Assert.Null(result.Error);
    }

    [Fact]
    public void ReplaceOrAdd_NewArmType_AddsIt()
    {
        var summary = new RunSummary();
        summary.Add(new RunResult("Microsoft.KeyVault/vaults", true, TimeSpan.FromSeconds(1), null));

        summary.ReplaceOrAdd(new RunResult("Microsoft.Storage/storageAccounts", true, TimeSpan.FromSeconds(1), null));

        Assert.Equal(2, summary.Results.Count);
    }

    [Fact]
    public async Task WriteAsync_WritesCorrectTotalsAndPerResultDetail()
    {
        var summary = new RunSummary();
        summary.Add(new RunResult("Microsoft.KeyVault/vaults", true, TimeSpan.FromSeconds(12.34), null, FieldCount: 8));
        summary.Add(new RunResult("Microsoft.Storage/storageAccounts", false, TimeSpan.FromSeconds(5), "QuotaExceeded"));

        await summary.WriteAsync(_outputRoot);

        using var doc = JsonDocument.Parse(await File.ReadAllTextAsync(Path.Combine(_outputRoot, "summary.json")));
        var root = doc.RootElement;
        Assert.Equal(2, root.GetProperty("total").GetInt32());
        Assert.Equal(1, root.GetProperty("succeeded").GetInt32());
        Assert.Equal(1, root.GetProperty("failed").GetInt32());

        var results = root.GetProperty("results").EnumerateArray().ToList();
        var vaultResult = results.Single(r => r.GetProperty("armType").GetString() == "Microsoft.KeyVault/vaults");
        Assert.True(vaultResult.GetProperty("success").GetBoolean());
        Assert.Equal(12.3, vaultResult.GetProperty("elapsedSeconds").GetDouble());
        Assert.Equal(8, vaultResult.GetProperty("fieldCount").GetInt32());

        var storageResult = results.Single(r => r.GetProperty("armType").GetString() == "Microsoft.Storage/storageAccounts");
        Assert.False(storageResult.GetProperty("success").GetBoolean());
        Assert.Equal("QuotaExceeded", storageResult.GetProperty("error").GetString());
    }

    // The whole reason zeroFieldArmTypes/zeroFieldCount exist — see AGENT.md's TimeoutException-
    // swallowing incident. Success=true with FieldCount=0 must be visible in the summary itself, not
    // just distinguishable in scrollback.
    [Fact]
    public async Task WriteAsync_SuccessWithZeroFieldCount_IsListedInZeroFieldArmTypes()
    {
        var summary = new RunSummary();
        summary.Add(new RunResult("Microsoft.DataProtection/backupVaults", true, TimeSpan.FromSeconds(1), null, FieldCount: 0));
        summary.Add(new RunResult("Microsoft.KeyVault/vaults", true, TimeSpan.FromSeconds(1), null, FieldCount: 5));
        // A failed unit never reached capture at all (FieldCount null) — must not be miscounted as
        // a zero-field capture, that's a structurally different case.
        summary.Add(new RunResult("Microsoft.Compute/disks", false, TimeSpan.FromSeconds(1), "ProvisioningFailed"));

        await summary.WriteAsync(_outputRoot);

        using var doc = JsonDocument.Parse(await File.ReadAllTextAsync(Path.Combine(_outputRoot, "summary.json")));
        var root = doc.RootElement;
        Assert.Equal(1, root.GetProperty("zeroFieldCount").GetInt32());
        var zeroFieldArmTypes = root.GetProperty("zeroFieldArmTypes").EnumerateArray().Select(e => e.GetString()).ToList();
        Assert.Equal(["Microsoft.DataProtection/backupVaults"], zeroFieldArmTypes);
    }

    [Fact]
    public async Task WriteAsync_NoResults_WritesZeroedTotalsAndEmptyLists()
    {
        var summary = new RunSummary();

        await summary.WriteAsync(_outputRoot);

        using var doc = JsonDocument.Parse(await File.ReadAllTextAsync(Path.Combine(_outputRoot, "summary.json")));
        var root = doc.RootElement;
        Assert.Equal(0, root.GetProperty("total").GetInt32());
        Assert.Empty(root.GetProperty("results").EnumerateArray());
        Assert.Empty(root.GetProperty("zeroFieldArmTypes").EnumerateArray());
    }
}
