using System.Text.Json;

namespace AzResourceDetailsDownloader.Config;

public sealed class ResourceTypeDefinition
{
    public required string ArmType { get; init; }
    public required string ApiVersion { get; init; }
    public required CostInfo Cost { get; init; }
    public string? Location { get; init; }
    // Tried in order, only after `Location` (or the default location) fails with a known Azure capacity/
    // availability error — not retried for any other failure, since a real validation or policy error would
    // just fail identically in every region.
    public IReadOnlyList<string>? LocationFallbacks { get; init; }
    public required string NameTemplate { get; init; }
    public NameRules? NameRules { get; init; }
    public required JsonElement RequestBody { get; init; }
    public IReadOnlyList<PrerequisiteDefinition> Prerequisites { get; init; } = [];
    public string? Notes { get; init; }
    public bool SlowProvisioning { get; init; }
    public int? EstimatedProvisionMinutes { get; init; }
}
