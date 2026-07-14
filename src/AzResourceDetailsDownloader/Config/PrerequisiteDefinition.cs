using System.Text.Json;

namespace AzResourceDetailsDownloader.Config;

public sealed class PrerequisiteDefinition
{
    public required string Alias { get; init; }
    public required string ArmType { get; init; }
    public required string ApiVersion { get; init; }
    public string? Location { get; init; }
    public required string NameTemplate { get; init; }
    public NameRules? NameRules { get; init; }
    public required JsonElement RequestBody { get; init; }
    public int? EstimatedProvisionMinutes { get; init; }
}
