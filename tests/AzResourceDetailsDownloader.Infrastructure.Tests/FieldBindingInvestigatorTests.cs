using AzResourceDetailsDownloader.Capture;

namespace AzResourceDetailsDownloader.Tests;

public class FieldBindingInvestigatorTests
{
    [Fact]
    public void BuildChaseJs_StartsWithAsyncArrowFunctionWrapper()
    {
        var js = FieldBindingInvestigator.BuildChaseJs(["Ve"]);

        Assert.StartsWith("async () => {", js);
    }

    [Fact]
    public void BuildChaseJs_EmbedsHelperNamesAsAJsonArrayLiteral()
    {
        var js = FieldBindingInvestigator.BuildChaseJs(["Ve", "Le"]);

        Assert.Contains("""const helperNames = ["Ve","Le"];""", js);
    }

    [Fact]
    public void BuildChaseJs_EmptyHelperNames_ProducesEmptyArrayLiteral()
    {
        var js = FieldBindingInvestigator.BuildChaseJs([]);

        Assert.Contains("const helperNames = [];", js);
    }

    // AKS's `he.W8`/`he.MF` shape (see this class's own header comment on cross-chunk/aliased
    // helpers) — a dotted name must round-trip through the JSON literal unescaped-but-safe, not be
    // mistaken for something requiring special handling at this layer (alias resolution happens
    // later, inside the embedded JS itself, not here).
    [Fact]
    public void BuildChaseJs_DottedHelperName_RoundTripsThroughTheJsonLiteral()
    {
        var js = FieldBindingInvestigator.BuildChaseJs(["he.W8", "he.MF"]);

        Assert.Contains("""const helperNames = ["he.W8","he.MF"];""", js);
    }

    // The chase logic (module resolution, distance-ranked declaration search, resource-string
    // lookup) is shared verbatim with EssentialsExtractor.DumpFiberBuilderSourceAsync's own anchor/
    // fiber-walk — see FindBuilderFunctionJsFragment's own comment for why. Asserting it's embedded
    // unmodified, not re-typed, is what actually guards against the two ever quietly diverging.
    [Fact]
    public void BuildChaseJs_IncludesTheSharedFiberWalkFragmentVerbatim()
    {
        var js = FieldBindingInvestigator.BuildChaseJs(["Ve"]);

        Assert.Contains(EssentialsExtractor.FindBuilderFunctionJsFragment, js);
    }
}
