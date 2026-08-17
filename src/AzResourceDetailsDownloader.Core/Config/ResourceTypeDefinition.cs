using System.Text.Json;

namespace AzResourceDetailsDownloader.Config;

public sealed class ResourceTypeDefinition
{
    public required string ArmType { get; init; }
    public required string ApiVersion { get; init; }
    public required CostInfo Cost { get; init; }
    public string? Location { get; init; }
    // Tried in order, only after `Location` (or the default location) fails with a known Azure capacity/
    // availability error — not retried for any other failure, since a real validation or policy error would
    // just fail identically in every region.
    public IReadOnlyList<string>? LocationFallbacks { get; init; }
    public required string NameTemplate { get; init; }
    public NameRules? NameRules { get; init; }
    public required JsonElement RequestBody { get; init; }
    public IReadOnlyList<PrerequisiteDefinition> Prerequisites { get; init; } = [];
    public string? Notes { get; init; }
    public bool SlowProvisioning { get; init; }
    public int? EstimatedProvisionMinutes { get; init; }
    // Scales every portal-capture-phase timeout (PortalCaptureService.HardCaptureTimeout,
    // EssentialsExtractor.PrimaryAppearTimeout/FallbackAppearTimeout) for a type whose Overview blade
    // is known to render slowly — a different axis from EstimatedProvisionMinutes, which only covers
    // ARM provisioning time and has no bearing on how long the *page itself* takes to load once the
    // resource already exists. A multiplier (not an absolute override) because the capture phase has
    // several layered timeouts that all need to move together proportionally, not just one. Absent
    // (null) means the default 1x — the common case. Live-evidenced (2026-08-15/16): a full-catalog
    // run's per-type capture duration correlates 0.984 between two independent runs — slowness here is
    // a stable property of the type, not noise, so a per-type override is worth having rather than
    // just bumping the global ceiling for everyone.
    public double? CaptureTimeoutMultiplier { get; init; }
    // A fixed wait AFTER ARM provisioning finishes but BEFORE the first portal navigation — a
    // different problem than CaptureTimeoutMultiplier, which only stretches timeouts *within* the
    // page-load/extraction attempt itself. Live-evidenced (2026-08-16): a debug HTML dump for
    // Microsoft.DataProtection/backupVaults showed the resource's own blade chrome (title, full
    // per-resource left-nav menu) had loaded correctly, but the content area was still showing a
    // loading-spinner (`fxs-progress-dots`) — and neither StableRenderWaiter's own built-in
    // reload-and-retry nor a 3-5x CaptureTimeoutMultiplier cleared it. That pattern (correct chrome,
    // stuck content, survives a reload) looks like Azure's backend hasn't finished making the
    // brand-new resource available to the Portal yet — an ARM-to-Portal propagation lag, not a slow
    // page render — for which waiting *longer within the same page load* doesn't help nearly as much
    // as waiting *before starting that load at all*. Absent (null) means no delay — the default,
    // common case.
    public int? PostProvisioningDelaySeconds { get; init; }
}
