using System.Diagnostics.CodeAnalysis;

namespace AzResourceDetailsDownloader.Reporting;

// FieldCount is null when no portal capture happened at all (the unit failed before/without
// reaching EssentialsExtractor) — distinct from 0, which means a capture genuinely completed but
// the Essentials panel yielded no fields (a real, if rare, outcome — see AGENT.md's "conclusively
// diagnosed as external Azure Portal bugs" cases). Surfaced in RunSummary so a silent extraction
// regression across a batch is visible in summary.json, not just a per-line log during the run.
//
// Plain data, no behavior — see NameRules.cs for why this is excluded rather than tested. (The
// logic that USES this record — RunSummary's zeroFieldArmTypes computation — is tested directly.)
[ExcludeFromCodeCoverage]
public sealed record RunResult(string ArmType, bool Success, TimeSpan Elapsed, string? Error, int? FieldCount = null);
