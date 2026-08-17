using AzResourceDetailsDownloader.Output;

namespace AzResourceDetailsDownloader.Tests;

public class CategoryKeyTests
{
    [Theory]
    [InlineData("AI + machine learning", "ai_machine_learning")]
    [InlineData("DevOps", "devops")]
    [InlineData("Virtual desktop infrastructure", "virtual_desktop_infrastructure")]
    [InlineData("uncategorized", "uncategorized")]
    public void From_ProducesExpectedFolderSafeKey(string category, string expected)
    {
        Assert.Equal(expected, CategoryKey.From(category));
    }

    [Fact]
    public void From_CollapsesRepeatedPunctuation_AndTrimsEdges()
    {
        Assert.Equal("a_b", CategoryKey.From("  A -- B!! "));
    }
}
