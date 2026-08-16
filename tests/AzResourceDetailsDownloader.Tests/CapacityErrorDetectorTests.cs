using AzResourceDetailsDownloader.Provisioning;

namespace AzResourceDetailsDownloader.Tests;

public class CapacityErrorDetectorTests
{
    [Fact]
    public void IsCapacityError_TrueForKnownCapacityHeavyUsage()
    {
        Assert.True(CapacityErrorDetector.IsCapacityError(
            "ManagedEnvironmentCapacityHeavyUsageError: no capacity available"));
    }

    // Live-hit repeatedly (2026-08-16) — a real error text seen when creating
    // Microsoft.App/managedEnvironments in norwayeast. Previously missing from this list meant the
    // prerequisite's own locationFallbacks (francecentral/swedencentral/eastus) never actually
    // triggered for this specific, genuinely region-scoped limit.
    [Fact]
    public void IsCapacityError_TrueForMaxRegionalEnvironmentsExceeded()
    {
        const string message = """
            {"error":{"code":"MaxNumberOfRegionalEnvironmentsInSubExceeded","message":"The subscription
            cannot have more than 1 Container App Environments in Norway East."}}
            """;

        Assert.True(CapacityErrorDetector.IsCapacityError(message));
    }

    [Fact]
    public void IsCapacityError_FalseForUnrelatedError()
    {
        Assert.False(CapacityErrorDetector.IsCapacityError("StorageAccountAlreadyTaken: the name is taken"));
    }

    [Fact]
    public void IsCapacityError_FalseForNull()
    {
        Assert.False(CapacityErrorDetector.IsCapacityError(null));
    }
}
