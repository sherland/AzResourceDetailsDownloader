using System.Text.RegularExpressions;
using AzResourceDetails.Templating;
using AzResourceDetailsDownloader.Options;

namespace AzResourceDetailsDownloader.Tests;

// Every generated template must only reference what AzResourceDetails.Templating's
// TemplateRuntimeContract actually declares — this is the enforcement side of that contract (see
// its own class doc comment). A template that starts referencing a new model field or a new custom
// function without the contract being updated to match would render fine against THIS repo's own
// TemplateRenderer (which always has the latest ScribanModelBuilder/TemplateFunctions in step) but
// silently fail against any other host — e.g. AzToMd — that only implements the documented
// contract. Catching that gap here, at template-generation time, is the whole point.
public class TemplateRuntimeContractTests
{
    // Scriban expression bodies only ("{{ ... }}") — scanning the raw file text directly would
    // false-positive on the plain markdown table syntax every template also contains (a table
    // header row literally reads "| Property | Value |", which looks identical to a pipe-transform
    // call to a regex that isn't scoped to inside {{ }} first — live-caught by this test itself).
    private static readonly Regex ExpressionPattern = new(@"\{\{(.*?)\}\}", RegexOptions.Compiled | RegexOptions.Singleline);

    // First segment after "model." — model.props.foo.bar[0] should only ever check "props", not
    // "foo"/"bar", since everything under props is an intentionally dynamic passthrough of the
    // resource's own ARM properties (see TemplateRuntimeContract's class comment).
    private static readonly Regex ModelFieldPattern = new(@"model\.([a-zA-Z_][a-zA-Z0-9_]*)", RegexOptions.Compiled);

    // A pipe-transform target not immediately followed by a dot — excludes Scriban standard-library
    // calls like "string.capitalize" (captures "string", then the lookahead rejects the match
    // because of the following '.'), which aren't part of this contract since every Scriban host
    // provides them already.
    private static readonly Regex PipeFunctionPattern =
        new(@"\|\s*([a-zA-Z_][a-zA-Z0-9_]*)\b(?!\.)", RegexOptions.Compiled);

    public static IEnumerable<object[]> TemplateFiles()
    {
        var repoRoot = RepoPaths.ResolveRepoRoot();
        var templatesDir = Path.Combine(repoRoot, "templates");
        if (!Directory.Exists(templatesDir))
        {
            yield break;
        }
        foreach (var path in Directory.EnumerateFiles(templatesDir, "*.sbn"))
        {
            yield return [path];
        }
    }

    [Theory]
    [MemberData(nameof(TemplateFiles))]
    public void Template_OnlyReferencesFieldsAndFunctionsInTheRuntimeContract(string templatePath)
    {
        var text = File.ReadAllText(templatePath);
        var expressions = string.Join('\n', ExpressionPattern.Matches(text).Select(m => m.Groups[1].Value));
        var supportedFields = new HashSet<string>(TemplateRuntimeContract.SupportedModelFields, StringComparer.Ordinal) { "props" };
        var supportedFunctions = new HashSet<string>(TemplateRuntimeContract.SupportedFunctions, StringComparer.Ordinal);

        var unsupportedFields = ModelFieldPattern.Matches(expressions)
            .Select(m => m.Groups[1].Value)
            .Distinct()
            .Where(f => !supportedFields.Contains(f))
            .ToList();
        var unsupportedFunctions = PipeFunctionPattern.Matches(expressions)
            .Select(m => m.Groups[1].Value)
            .Distinct()
            .Where(f => !supportedFunctions.Contains(f))
            .ToList();

        Assert.True(unsupportedFields.Count == 0,
            $"{templatePath} references model field(s) not in TemplateRuntimeContract.SupportedModelFields: " +
            $"{string.Join(", ", unsupportedFields)}");
        Assert.True(unsupportedFunctions.Count == 0,
            $"{templatePath} references function(s) not in TemplateRuntimeContract.SupportedFunctions " +
            $"(and not a Scriban standard-library call): {string.Join(", ", unsupportedFunctions)}");
    }

    // The inverse check: every field the contract declares should actually be reachable from
    // ScribanModelBuilder.BuildModel's output, catching the contract drifting stale in the OTHER
    // direction (a field removed from the builder but left listed as supported).
    [Fact]
    public void RuntimeContract_EveryDeclaredModelField_IsActuallyPopulatedByScribanModelBuilder()
    {
        var root = System.Text.Json.JsonDocument.Parse("""
            {
              "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Test/things/thing1",
              "name": "thing1",
              "location": "norwayeast",
              "sku": { "tier": "Standard", "name": "Standard_LRS", "capacity": 1 },
              "properties": {}
            }
            """).RootElement;

        var model = ScribanModelBuilder.BuildModel(root, "Microsoft.Test/things");

        foreach (var field in TemplateRuntimeContract.SupportedModelFields)
        {
            Assert.True(model.ContainsKey(field), $"model.{field} is declared in the contract but BuildModel never sets it.");
        }
    }
}
