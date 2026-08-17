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

    [Fact]
    public void ResourceProviderRegistrationErrorDetector_ExtractsNamespace()
    {
        var found = ResourceProviderRegistrationErrorDetector.TryGetUnregisteredNamespace(
            "{\"error\":{\"code\":\"MissingSubscriptionRegistration\",\"message\":\"The subscription is not registered to use namespace 'Microsoft.Maps'. See https://aka.ms/rps-not-found for how to register subscriptions.\"}}",
            out var namespaceName);

        Assert.True(found);
        Assert.Equal("Microsoft.Maps", namespaceName);
    }

    [Fact]
    public void ResourceProviderRegistrationErrorDetector_ExtractsNamespace_FromRpNotRegisteredShape()
    {
        // Distinct wording from the MissingSubscriptionRegistration case above — live-observed from
        // Microsoft.AzureTerraform's exportTerraform action (IacExportService), a separate code path
        // from the main ARM PUT provisioning flow.
        var found = ResourceProviderRegistrationErrorDetector.TryGetUnregisteredNamespace(
            "{\"error\":{\"code\":\"RPNotRegistered\",\"message\":\"Resource Provider not registered, please make sure the resource provider 'Microsoft.AzureTerraform' is registered on the subscription. Please refer to documentation how to register at https://aka.ms/AzureTerraformRPRegistration\"}}",
            out var namespaceName);

        Assert.True(found);
        Assert.Equal("Microsoft.AzureTerraform", namespaceName);
    }

    [Fact]
    public void ResourceProviderRegistrationErrorDetector_IgnoresUnrelatedError()
    {
        Assert.False(ResourceProviderRegistrationErrorDetector.TryGetUnregisteredNamespace(
            "OperationNotAllowed: the operation is not supported for this resource type", out _));
    }

    [Fact]
    public void ResourceProviderRegistrationErrorDetector_IgnoresNullMessage()
    {
        Assert.False(ResourceProviderRegistrationErrorDetector.TryGetUnregisteredNamespace(null, out _));
    }
}
