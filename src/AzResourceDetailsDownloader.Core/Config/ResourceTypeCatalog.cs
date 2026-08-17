using System.Text.Json.Serialization;

namespace AzResourceDetailsDownloader.Config;

public sealed class ResourceTypeCatalog
{
    [JsonPropertyName("$schemaVersion")]
    public int SchemaVersion { get; init; }

    // Set by fetch-resource-pricing.ps1 each time it runs (mirrors resource-abbreviations.json's
    // own fetchedUtc field) — null on a catalog that's never had pricing fetched yet.
    public DateTimeOffset? PricingFetchedUtc { get; init; }

    public required IReadOnlyList<ResourceTypeDefinition> ResourceTypes { get; init; }
}
