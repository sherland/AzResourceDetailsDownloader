namespace AzResourceDetailsDownloader.Config;

public enum CostTier
{
    Free,
    Low,
    Medium,
    High,
    // Genuinely expensive even for a brief capture (hundreds to thousands of $/month if left running, or
    // hours to provision) — cataloged for full architectural coverage, but never included by any
    // --max-cost-tier below VeryHigh, and only ever run with an explicit --max-cost-tier VeryHigh.
    VeryHigh
}
