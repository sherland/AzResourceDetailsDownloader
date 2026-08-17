namespace AzResourceDetailsDownloader.Options;

public static class RepoPaths
{
    public static string ResolveRepoRoot()
    {
        var dir = new DirectoryInfo(AppContext.BaseDirectory);
        while (dir is not null)
        {
            if (dir.GetFiles("*.sln").Length > 0 || dir.GetFiles("*.slnx").Length > 0)
            {
                return dir.FullName;
            }

            dir = dir.Parent;
        }

        throw new InvalidOperationException(
            $"Could not locate the repository root (a directory containing a .sln or .slnx file) above '{AppContext.BaseDirectory}'.");
    }

    public static string Resolve(string repoRoot, string relativeOrAbsolutePath) =>
        Path.IsPathRooted(relativeOrAbsolutePath)
            ? relativeOrAbsolutePath
            : Path.GetFullPath(Path.Combine(repoRoot, relativeOrAbsolutePath));
}
