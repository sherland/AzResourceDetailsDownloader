using AzResourceDetailsDownloader.Provisioning;

namespace AzResourceDetailsDownloader.Tests;

public class NameGeneratorTests
{
    [Fact]
    public void RandomString_LowerAlnum_ProducesOnlyLowercaseLettersAndDigits()
    {
        var result = NameGenerator.RandomString(20, "lowerAlnum", new Random(42));

        Assert.Equal(20, result.Length);
        Assert.Matches("^[a-z0-9]+$", result);
    }

    [Fact]
    public void RandomString_Hex_ProducesOnlyLowercaseHexDigits()
    {
        var result = NameGenerator.RandomString(16, "hex", new Random(42));

        Assert.Equal(16, result.Length);
        Assert.Matches("^[0-9a-f]+$", result);
    }

    [Fact]
    public void RandomString_UnknownCharset_Throws()
    {
        Assert.Throws<InvalidOperationException>(() => NameGenerator.RandomString(10, "bogus", new Random(42)));
    }

    [Fact]
    public void RandomString_SameSeed_IsDeterministic()
    {
        var a = NameGenerator.RandomString(20, "lowerAlnum", new Random(123));
        var b = NameGenerator.RandomString(20, "lowerAlnumDash", new Random(123));

        var aAgain = NameGenerator.RandomString(20, "lowerAlnum", new Random(123));
        var bAgain = NameGenerator.RandomString(20, "lowerAlnumDash", new Random(123));

        Assert.Equal(a, aAgain);
        Assert.Equal(b, bAgain);
    }

    // Many ARM resource types allow dashes but reject a leading/trailing dash or consecutive dashes
    // (Service Bus namespaces confirmed) — this charset must never produce any of those shapes.
    // Run across many seeds/lengths since dash placement is randomized; a single seed could pass by
    // luck even with a broken boundary check.
    [Theory]
    [InlineData(3)]
    [InlineData(10)]
    [InlineData(24)]
    public void RandomString_LowerAlnumDash_NeverProducesLeadingTrailingOrConsecutiveDashes(int length)
    {
        for (var seed = 0; seed < 200; seed++)
        {
            var result = NameGenerator.RandomString(length, "lowerAlnumDash", new Random(seed));

            Assert.Matches("^[a-z0-9-]+$", result);
            Assert.DoesNotMatch("^-|-$|--", result);
        }
    }
}
