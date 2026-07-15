using AzResourceDetailsDownloader.Provisioning;

namespace AzResourceDetailsDownloader.Tests;

public class ErrorDetectorTests
{
    [Fact]
    public void CapacityErrorDetector_RecognizesKnownCode()
    {
        Assert.True(CapacityErrorDetector.IsCapacityError(
            "ErrorCode: ManagedEnvironmentCapacityHeavyUsageError, Message: Creating a new managed environment is unavailable"));
    }

    [Fact]
    public void CapacityErrorDetector_IgnoresUnrelatedError()
    {
        Assert.False(CapacityErrorDetector.IsCapacityError("RequestDisallowedByPolicy: naming convention violated"));
    }

    [Fact]
    public void QuotaErrorDetector_RecognizesOperationNotAllowedWithQuota()
    {
        Assert.True(QuotaErrorDetector.IsQuotaError(
            "OperationNotAllowed: Operation could not be completed as it results in exceeding approved standardDSv5Family Cores quota."));
    }

    [Fact]
    public void QuotaErrorDetector_RecognizesQuotaExceededCode()
    {
        Assert.True(QuotaErrorDetector.IsQuotaError("QuotaExceeded: storage account limit reached"));
    }

    [Fact]
    public void QuotaErrorDetector_IgnoresUnrelatedOperationNotAllowed()
    {
        Assert.False(QuotaErrorDetector.IsQuotaError("OperationNotAllowed: the operation is not supported for this resource type"));
    }
}
