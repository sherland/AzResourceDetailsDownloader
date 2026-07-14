using System.Text.Json.Serialization;

namespace AzResourceDetailsDownloader.Config;

public sealed class ResourceTypeCatalog
{
    [JsonPropertyName("$schemaVersion")]
    public int SchemaVersion { get; init; }

    public required IReadOnlyList<ResourceTypeDefinition> ResourceTypes { get; init; }
}
