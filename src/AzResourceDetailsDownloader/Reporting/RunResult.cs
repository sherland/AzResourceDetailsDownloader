namespace AzResourceDetailsDownloader.Reporting;

public sealed record RunResult(string ArmType, bool Success, TimeSpan Elapsed, string? Error);
