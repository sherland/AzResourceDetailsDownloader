using System.Text.Json;

namespace AzResourceDetailsDownloader.Config;

public sealed class PrerequisiteDefinition
{
    public required string Alias { get; init; }
    public required string ArmType { get; init; }
    public required string ApiVersion { get; init; }
    public string? Location { get; init; }
    public IReadOnlyList<string>? LocationFallbacks { get; init; }
    public required string NameTemplate { get; init; }
    public NameRules? NameRules { get; init; }
    public required JsonElement RequestBody { get; init; }
    public int? EstimatedProvisionMinutes { get; init; }

    // Rolled up into the owning entry's Cost.PerHourAccumulated by fetch-resource-pricing.ps1. Prerequisites
    // aren't independently tier-gated, so they get only this flat rate, not a full CostInfo.
    public decimal? PerHour { get; init; }
}
