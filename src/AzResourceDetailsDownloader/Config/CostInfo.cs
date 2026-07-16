namespace AzResourceDetailsDownloader.Config;

// Populated by fetch-resource-pricing.ps1 from the Azure Retail Prices API (rate/meter fields) plus
// config/pricing-hints.json (MinimumUnits, which that API cannot supply — see the hints file's own comments).
// Every field except Tier is nullable: most catalog entries have no meaningful per-hour cost at all (storage,
// networking, consumption-billed services sit idle at $0), and null is the honest answer for those, not 0.
public sealed class CostInfo
{
    public required CostTier Tier { get; init; }

    // Azure's own unitOfMeasure string verbatim (e.g. "1 Hour", "1/Day", "1/Month") — the real billing
    // granularity of PerUnitRate, which is NOT always hourly (e.g. SQL elastic pools bill "1/Day", DNS
    // zone hosting and Front Door base fees bill "1/Month"). PerHour/PerHourAccumulated below are always
    // true $/hour figures regardless of BillingUnit — fetch-resource-pricing.ps1 normalizes them.
    public string? BillingUnit { get; init; }

    // The raw, as-billed meter rate from the Retail Prices API, in BillingUnit's own granularity (e.g.
    // $/vCore-hour, or $/zone/month) — before multiplying by quantity and before hourly normalization.
    public decimal? PerUnitRate { get; init; }

    // The service's real hard-floor purchase quantity (e.g. Stream Analytics can't be bought below 36 SUs) —
    // hand-curated in pricing-hints.json, since the Retail Prices API has no such field.
    public int? MinimumUnits { get; init; }

    // The entry's own true $/hour cost only (excluding prerequisites): PerUnitRate normalized to hourly
    // (converting away from BillingUnit's real granularity) times max(MinimumUnits, the entry's own
    // requestBody quantity).
    public decimal? PerHour { get; init; }

    // PerHour plus the recursive sum of every prerequisite's own PerHour.
    public decimal? PerHourAccumulated { get; init; }

    // A one-off creation fee distinct from ongoing rate, if a service ever charges one. Null for everything
    // researched so far.
    public decimal? OneTimeSetupCost { get; init; }

    // Traceability back to the exact Retail Prices API record this was resolved from.
    public string? MeterId { get; init; }
    public string? MeterName { get; init; }
    public string? ProductName { get; init; }
    public string? ArmRegionName { get; init; }
}
