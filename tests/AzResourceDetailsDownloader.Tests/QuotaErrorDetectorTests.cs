using AzResourceDetailsDownloader.Provisioning;

namespace AzResourceDetailsDownloader.Tests;

public class QuotaErrorDetectorTests
{
    [Fact]
    public void IsQuotaError_TrueForQuotaExceeded()
    {
        Assert.True(QuotaErrorDetector.IsQuotaError("QuotaExceeded: something"));
    }

    [Fact]
    public void IsQuotaError_TrueForOperationNotAllowedWithQuota()
    {
        Assert.True(QuotaErrorDetector.IsQuotaError(
            "OperationNotAllowed: exceeding approved standardDSv5Family Cores quota"));
    }

    // Live-hit repeatedly (2026-08-15/16) — a real error text seen across several full-catalog runs,
    // not a synthetic example. Previously bypassed the retry-at-lower-concurrency pass entirely
    // because it matches neither of the two patterns above.
    [Fact]
    public void IsQuotaError_TrueForAppServicePlanThrottled()
    {
        const string message = """
            {"Code":"429","Message":"App Service Plan Create operation is throttled for subscription
            deafd2fb-c3d6-47f5-9645-cc34d54d4317. Please contact support if issue persists.","Target":null}
            """;

        Assert.True(QuotaErrorDetector.IsQuotaError(message));
    }

    [Fact]
    public void IsQuotaError_FalseForUnrelatedError()
    {
        Assert.False(QuotaErrorDetector.IsQuotaError("StorageAccountAlreadyTaken: the name is taken"));
    }

    [Fact]
    public void IsQuotaError_FalseForNull()
    {
        Assert.False(QuotaErrorDetector.IsQuotaError(null));
    }
}
