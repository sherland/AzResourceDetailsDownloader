namespace AzResourceDetailsDownloader.Provisioning;

// Recognizes Azure error codes that mean "this region/SKU combination is temporarily out of capacity" as
// opposed to a real validation/policy failure that would recur identically in any region. Only
// ManagedEnvironmentCapacityHeavyUsageError has actually been observed live in this project (Container Apps
// environments in westeurope); the others are Azure's own documented codes for the same class of failure on
// other resource types and are included so the location-fallback mechanism generalizes, but haven't been
// live-verified here — extend this list from real failures as they're seen, not from guessing.
public static class CapacityErrorDetector
{
    private static readonly string[] KnownCapacityErrorCodes =
    [
        "ManagedEnvironmentCapacityHeavyUsageError",
        "AllocationFailed",
        "ZonalAllocationFailed",
        "OverconstrainedAllocationRequest",
        "SkuNotAvailable",
        // Live-hit repeatedly (2026-08-16), Microsoft.App/managedEnvironments in norwayeast: "cannot
        // have more than 1 Container App Environments in Norway East" — a per-*region* cap, which is
        // exactly the shape this detector exists to catch (a different region genuinely sidesteps it,
        // unlike a real validation/policy error). This entry's own locationFallbacks list
        // (francecentral/swedencentral/eastus) already existed but never actually triggered, because
        // this specific error code was missing from this list — confirmed live: a retry-at-lower-
        // concurrency pass (the *other* fallback mechanism, for QuotaErrorDetector-shaped errors)
        // doesn't help this one at all, since it isn't a concurrency-collision problem.
        "MaxNumberOfRegionalEnvironmentsInSubExceeded"
    ];

    public static bool IsCapacityError(string? message) =>
        message is not null && KnownCapacityErrorCodes.Any(code => message.Contains(code, StringComparison.Ordinal));
}
