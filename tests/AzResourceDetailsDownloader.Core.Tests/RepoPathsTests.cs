using AzResourceDetailsDownloader.Options;

namespace AzResourceDetailsDownloader.Tests;

public class RepoPathsTests
{
    // No mocking needed: a real test run's AppContext.BaseDirectory genuinely sits under this
    // checked-out repo (which has a real .slnx at its root), so walking up from there is exactly
    // the real-world scenario this method exists for, not a special case.
    [Fact]
    public void ResolveRepoRoot_FindsARealDirectoryContainingASolutionFile()
    {
        var repoRoot = RepoPaths.ResolveRepoRoot();

        Assert.True(Directory.Exists(repoRoot));
        Assert.True(
            Directory.GetFiles(repoRoot, "*.sln").Length > 0 || Directory.GetFiles(repoRoot, "*.slnx").Length > 0);
    }

    [Fact]
    public void Resolve_RootedPath_ReturnedUnchanged()
    {
        var rooted = Path.Combine(Path.GetTempPath(), "some-absolute-path");

        var result = RepoPaths.Resolve("/some/repo/root", rooted);

        Assert.Equal(rooted, result);
    }

    [Fact]
    public void Resolve_RelativePath_CombinedWithRepoRootAndFullyQualified()
    {
        var repoRoot = RepoPaths.ResolveRepoRoot();

        var result = RepoPaths.Resolve(repoRoot, "config/resource-types.json");

        Assert.True(Path.IsPathRooted(result));
        Assert.Equal(Path.GetFullPath(Path.Combine(repoRoot, "config/resource-types.json")), result);
    }
}
