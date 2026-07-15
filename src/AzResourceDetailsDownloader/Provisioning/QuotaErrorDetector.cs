namespace AzResourceDetailsDownloader.Provisioning;

// Distinct from CapacityErrorDetector: that one means "no capacity anywhere right now, try another region";
// this one means "your subscription's own approved quota (usually vCPU cores per VM family/region) is used
// up" — switching regions doesn't help (quota is granted per subscription+region+family), only running
// fewer compute-heavy units concurrently does. Azure's classic shape for this is the generic
// "OperationNotAllowed" code with "quota" in the message text (e.g. "exceeding approved standardDSv5Family
// Cores quota") — based on Azure's well-documented, extremely common error pattern rather than a live
// reproduction in this project (deliberately exhausting a subscription's core quota just to test this isn't
// a reasonable thing to do against a shared sandbox). Extend/correct this from a real failure if the pattern
// doesn't match what you actually see.
public static class QuotaErrorDetector
{
    public static bool IsQuotaError(string? message) =>
        message is not null
        && (message.Contains("QuotaExceeded", StringComparison.Ordinal)
            || (message.Contains("OperationNotAllowed", StringComparison.Ordinal)
                && message.Contains("quota", StringComparison.OrdinalIgnoreCase)));
}
