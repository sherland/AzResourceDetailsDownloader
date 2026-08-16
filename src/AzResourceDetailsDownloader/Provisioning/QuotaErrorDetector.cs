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
                && message.Contains("quota", StringComparison.OrdinalIgnoreCase))
            // Live-hit repeatedly (2026-08-15/16, 0-6 occurrences per full-catalog run): "App Service
            // Plan Create operation is throttled for subscription ... Please contact support if issue
            // persists" — HTTP 429, ExtendedCode 51025. A genuinely different shape from the two above
            // (no "QuotaExceeded", no "OperationNotAllowed"), so it silently bypassed the retry-at-
            // lower-concurrency pass entirely until now. The inconsistent per-run count (0 in one run,
            // 6 in another) is itself evidence this is a real, transient, concurrency-sensitive rate
            // limit — exactly what the quieter retry pass below already exists to smooth over for
            // every *other* quota shape; this one just needed to be recognized in the first place.
            || message.Contains("operation is throttled", StringComparison.OrdinalIgnoreCase));
}
