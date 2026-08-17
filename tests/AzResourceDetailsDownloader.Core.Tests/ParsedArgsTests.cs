using AzResourceDetailsDownloader.Cli;

namespace AzResourceDetailsDownloader.Tests;

public class ParsedArgsTests
{
    [Fact]
    public void Parse_NoArgs_DefaultsToDryRun()
    {
        var result = ParsedArgs.Parse([]);

        Assert.Equal(RunMode.DryRun, result.Mode);
        Assert.Null(result.OnlyArmTypes);
        Assert.Null(result.MaxCostTierOverride);
        Assert.Null(result.MaxConcurrencyOverride);
        Assert.Null(result.NamePrefixOverride);
        Assert.False(result.LiveUi);
    }

    [Theory]
    [InlineData("--login", RunMode.Login)]
    [InlineData("--run", RunMode.Run)]
    [InlineData("--dry-run", RunMode.DryRun)]
    [InlineData("--generate-field-recipes", RunMode.GenerateFieldRecipes)]
    [InlineData("--generate-templates", RunMode.GenerateTemplates)]
    public void Parse_ModeFlags_SetTheExpectedMode(string flag, RunMode expected)
    {
        var result = ParsedArgs.Parse([flag]);

        Assert.Equal(expected, result.Mode);
    }

    [Fact]
    public void Parse_LaterModeFlagWins_WhenMultiplePassed()
    {
        var result = ParsedArgs.Parse(["--dry-run", "--run"]);

        Assert.Equal(RunMode.Run, result.Mode);
    }

    [Fact]
    public void Parse_Only_SplitsTrimsAndDedupesCaseInsensitively()
    {
        var result = ParsedArgs.Parse(["--only", " Microsoft.KeyVault/vaults ,Microsoft.Storage/storageAccounts,,microsoft.keyvault/vaults"]);

        Assert.NotNull(result.OnlyArmTypes);
        Assert.Equal(2, result.OnlyArmTypes.Count);
        Assert.Contains("Microsoft.KeyVault/vaults", result.OnlyArmTypes);
        Assert.Contains("Microsoft.Storage/storageAccounts", result.OnlyArmTypes);
    }

    [Fact]
    public void Parse_MaxCostTier_SetsTheOverride()
    {
        var result = ParsedArgs.Parse(["--max-cost-tier", "High"]);

        Assert.Equal("High", result.MaxCostTierOverride);
    }

    [Fact]
    public void Parse_MaxConcurrency_ParsesAPositiveInteger()
    {
        var result = ParsedArgs.Parse(["--max-concurrency", "8"]);

        Assert.Equal(8, result.MaxConcurrencyOverride);
    }

    [Theory]
    [InlineData("0")]
    [InlineData("-1")]
    [InlineData("not-a-number")]
    public void Parse_MaxConcurrency_RejectsNonPositiveOrNonNumeric(string raw)
    {
        Assert.Throws<ArgumentException>(() => ParsedArgs.Parse(["--max-concurrency", raw]));
    }

    [Fact]
    public void Parse_NamePrefix_SetsTheOverride()
    {
        var result = ParsedArgs.Parse(["--name-prefix", "ci"]);

        Assert.Equal("ci", result.NamePrefixOverride);
    }

    [Fact]
    public void Parse_LiveUi_SetsTheFlag()
    {
        var result = ParsedArgs.Parse(["--dry-run", "--live-ui"]);

        Assert.True(result.LiveUi);
    }

    [Fact]
    public void Parse_UnrecognizedArgument_Throws()
    {
        var ex = Assert.Throws<ArgumentException>(() => ParsedArgs.Parse(["--bogus-flag"]));

        Assert.Contains("--bogus-flag", ex.Message);
    }

    [Theory]
    [InlineData("--only")]
    [InlineData("--max-cost-tier")]
    [InlineData("--max-concurrency")]
    [InlineData("--name-prefix")]
    public void Parse_ValueFlagWithNoTrailingValue_Throws(string flag)
    {
        Assert.Throws<ArgumentException>(() => ParsedArgs.Parse([flag]));
    }

    [Fact]
    public void Parse_CombinesMultipleFlagsInOnePass()
    {
        var result = ParsedArgs.Parse(
            ["--run", "--only", "Microsoft.KeyVault/vaults", "--max-cost-tier", "Low", "--max-concurrency", "2", "--name-prefix", "x", "--live-ui"]);

        Assert.Equal(RunMode.Run, result.Mode);
        Assert.Equal(["Microsoft.KeyVault/vaults"], result.OnlyArmTypes);
        Assert.Equal("Low", result.MaxCostTierOverride);
        Assert.Equal(2, result.MaxConcurrencyOverride);
        Assert.Equal("x", result.NamePrefixOverride);
        Assert.True(result.LiveUi);
    }
}
