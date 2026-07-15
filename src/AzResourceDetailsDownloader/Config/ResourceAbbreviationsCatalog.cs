namespace AzResourceDetailsDownloader.Config;

public sealed class ResourceAbbreviationsCatalog
{
    public required string SourceUrl { get; init; }
    public required string FetchedUtc { get; init; }
    public required IReadOnlyList<AbbreviationEntry> Entries { get; init; }
}

public sealed class AbbreviationEntry
{
    public required string Category { get; init; }
    public required string Resource { get; init; }
    public required string ResourceProviderNamespace { get; init; }
    public string? KindQualifier { get; init; }
    public required string Abbreviation { get; init; }
}
