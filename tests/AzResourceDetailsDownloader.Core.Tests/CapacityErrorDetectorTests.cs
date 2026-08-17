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

    // Live-hit repeatedly (2026-08-16) — a real error text seen when creating
    // Microsoft.Automation/automationAccounts in a region this tool had just finished tearing down
    // (its ephemeral resource groups delete on every capture, which is exactly what re-triggers this
    // for whichever region was used last). Plain "code":"BadRequest" from a direct ARM PUT, no
    // nested "error" wrapper — the distinctive phrase itself is what's matched.
    [Fact]
    public void IsCapacityError_TrueForAutomationAccountOnePerRegion()
    {
        const string message =
            """{"code":"BadRequest","message":"Only one account is allowed for your subscription per Region. If Deleted recently, please restore the same account"}""";

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
