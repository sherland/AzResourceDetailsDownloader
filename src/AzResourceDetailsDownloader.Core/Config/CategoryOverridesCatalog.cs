namespace AzResourceDetailsDownloader.Config;

public sealed class CategoryOverridesCatalog
{
    public required IReadOnlyList<CategoryOverride> Overrides { get; init; }
}

public sealed class CategoryOverride
{
    public required string ArmType { get; init; }
    public required string Category { get; init; }
    public required string Reason { get; init; }
}
