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
        "SkuNotAvailable"
    ];

    public static bool IsCapacityError(string? message) =>
        message is not null && KnownCapacityErrorCodes.Any(code => message.Contains(code, StringComparison.Ordinal));
}
