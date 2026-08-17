namespace AzResourceDetailsDownloader.Capture;

// Lives in Core, not alongside EssentialsExtractor in Infrastructure: it's a plain data record with
// zero Playwright dependency, and OutputWriter/OutputNormalizer (both Core) need it as a parameter
// type. Infrastructure's EssentialsExtractor.ExtractAsync returns IReadOnlyList<PortalField> — a
// normal Infrastructure-produces/Core-defines-the-contract relationship, not a boundary violation.
public sealed record PortalField(string Label, string Value);
