using Microsoft.Extensions.Logging;
using Microsoft.Playwright;

namespace AzResourceDetailsDownloader.Capture;

public sealed record PortalCaptureResult(byte[] Screenshot, IReadOnlyList<string> Notices, IReadOnlyList<PortalField> Fields);

// Thread-safe: multiple units can call CaptureAsync concurrently (each running its own ARM provisioning
// in parallel), but there is only one browser page/tab — reused deliberately across the whole batch to
// avoid re-triggering MFA — so actual page navigation/screenshot work is serialized behind `_captureLock`.
// Callers don't need their own locking; queueing here is transparent to them.
public sealed class PortalCaptureService : IAsyncDisposable
{
    private readonly IPlaywright _playwright;
    private readonly IBrowser _browser;
    private readonly IBrowserContext _context;
    private readonly IPage _page;
    private readonly string _portalBaseUrl;
    private readonly string _tenantId;
    private readonly SemaphoreSlim _captureLock = new(1, 1);

    private PortalCaptureService(
        IPlaywright playwright, IBrowser browser, IBrowserContext context, IPage page,
        string portalBaseUrl, string tenantId)
    {
        _playwright = playwright;
        _browser = browser;
        _context = context;
        _page = page;
        _portalBaseUrl = portalBaseUrl;
        _tenantId = tenantId;
    }

    public static async Task<PortalCaptureService> CreateAsync(
        string portalBaseUrl, string tenantId, string storageStatePath, bool headless = true)
    {
        if (!File.Exists(storageStatePath))
        {
            throw new InvalidOperationException($"No saved portal session at '{storageStatePath}'. Run with --login first.");
        }

        var playwright = await Playwright.CreateAsync();
        var browser = await playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions { Headless = headless });
        var context = await browser.NewContextAsync(new BrowserNewContextOptions
        {
            StorageStatePath = storageStatePath,
            ViewportSize = new ViewportSize { Width = 1920, Height = 1080 }
        });
        var page = await context.NewPageAsync();

        return new PortalCaptureService(playwright, browser, context, page, portalBaseUrl, tenantId);
    }

    private static readonly TimeSpan HardCaptureTimeout = TimeSpan.FromSeconds(90);

    // Extra time given to an already-timed-out capture before the lock is released to the next queued
    // unit — see the race-condition comment inside CaptureAsync for why this exists at all. Deliberately
    // NOT "wait as long as it takes": that would silently reintroduce the exact whole-batch-stall risk
    // HardCaptureTimeout exists to bound. 60s is a compromise, not a guarantee — a capture that's
    // merely somewhat slower than 90s gets a real chance to finish cleanly before the next unit touches
    // the shared page; a genuinely stuck one still only costs the batch HardCaptureTimeout + this, not
    // forever.
    private static readonly TimeSpan OrphanedCaptureGracePeriod = TimeSpan.FromSeconds(60);

    public async Task<PortalCaptureResult> CaptureAsync(
        string resourceId, string resourceName, ILogger logger, double captureTimeoutMultiplier = 1.0, CancellationToken ct = default)
    {
        // Queueing for the lock is unbounded on purpose — it just means another unit's screenshot is in
        // progress, not that anything is stuck. The hard timeout below only starts counting once this
        // unit actually has the page to itself.
        await _captureLock.WaitAsync(ct);
        try
        {
            // Belt-and-suspenders: StableRenderWaiter already bounds its own waits, but this hard ceiling
            // guarantees one stuck capture can never stall the whole batch, whatever the root cause turns
            // out to be. Scaled by captureTimeoutMultiplier (config's captureTimeoutMultiplier, see
            // ResourceTypeDefinition) for types with a known-slow Overview blade — evidenced live
            // (2026-08-15/16) by a 0.984 cross-run correlation in per-type capture duration, i.e. slowness
            // here is a stable property of the type, not noise worth a blanket global increase instead.
            var hardCaptureTimeout = HardCaptureTimeout * captureTimeoutMultiplier;
            var captureTask = CaptureCoreAsync(resourceId, resourceName, logger, captureTimeoutMultiplier, ct);
            var timeoutTask = Task.Delay(hardCaptureTimeout, ct);

            var winner = await Task.WhenAny(captureTask, timeoutTask);
            if (winner == timeoutTask)
            {
                // Live-found (2026-08-15): `captureTask` is NOT actually cancelled here — Playwright's
                // async page/frame APIs don't accept a token that aborts an in-flight operation, so it
                // keeps running against `_page` in the background regardless of what this method does
                // next. The comment this replaced said "navigating the shared page to the next
                // resource's URL implicitly abandons whatever this call left in flight" — that's true
                // for what THIS unit sees, but wrong about what happens to the page: releasing the lock
                // immediately here lets the NEXT queued unit start its own `_page.GotoAsync(...)` while
                // this orphaned task might still be mid-navigation or mid-EssentialsExtractor.ExtractAsync
                // on the exact same page object — two units genuinely racing on shared browser state.
                // Reproduced across two independent full-catalog runs: a consistent ~30-type set kept
                // extracting 0 Essentials fields (not a clean timeout failure, a silently-wrong empty
                // result) identical whether or not an unrelated same-day EssentialsExtractor fix was
                // present, ruling that fix out as the cause and pointing at something structural instead.
                // Waiting here (bounded, see OrphanedCaptureGracePeriod) before releasing the lock doesn't
                // fully solve the underlying problem — Playwright still can't truly cancel the orphaned
                // task — but it meaningfully shrinks the window in which two units can touch `_page` at
                // once, for the common case where the orphaned task was only somewhat slower than 90s
                // rather than genuinely stuck.
                await Task.WhenAny(captureTask, Task.Delay(OrphanedCaptureGracePeriod * captureTimeoutMultiplier, ct));
                throw new TimeoutException(
                    $"Portal capture for '{resourceId}' ('{resourceName}') did not complete within {hardCaptureTimeout.TotalSeconds}s.");
            }

            return await captureTask;
        }
        finally
        {
            _captureLock.Release();
        }
    }

    private async Task<PortalCaptureResult> CaptureCoreAsync(
        string resourceId, string resourceName, ILogger logger, double captureTimeoutMultiplier, CancellationToken ct)
    {
        var url = PortalUrlBuilder.BuildOverviewUrl(_portalBaseUrl, _tenantId, resourceId);
        logger.LogInformation("    portal: navigating to {Url}", url);
        await _page.GotoAsync(url, new PageGotoOptions { WaitUntil = WaitUntilState.DOMContentLoaded });

        logger.LogInformation("    portal: navigation complete, waiting for stable render");
        await StableRenderWaiter.WaitForStableRenderAsync(_page, resourceName, logger, ct);

        logger.LogInformation("    portal: render stable, taking screenshot");
        var bytes = await _page.ScreenshotAsync(new PageScreenshotOptions { FullPage = true });
        logger.LogInformation("    portal: screenshot captured ({Bytes} bytes)", bytes.Length);

        // Diagnostic aid, kept permanently: dumps raw HTML around the Essentials panel so the
        // EssentialsExtractor selector can be re-verified/adjusted against real markup if Azure
        // Portal's DOM ever changes. No-op unless the env var is set — see AGENT.md.
        var debugDir = Environment.GetEnvironmentVariable("ARDL_DEBUG_ESSENTIALS_DIR");
        if (!string.IsNullOrEmpty(debugDir))
        {
            var safeName = string.Join("_", resourceName.Split(Path.GetInvalidFileNameChars()));
            await EssentialsExtractor.DumpDebugHtmlAsync(_page, Path.Combine(debugDir, $"{safeName}.html"));
            await EssentialsExtractor.DumpFiberBuilderSourceAsync(_page, Path.Combine(debugDir, $"{safeName}.essentials-source.json"));

            // Opt-in second hop (see FieldBindingInvestigator's class comment for the full
            // technique and its robustness/limitation notes): chases each named helper function
            // referenced by the field-builder source dumped just above into whichever other loaded
            // script actually defines it, plus the resource-string table backing its display text.
            // Only runs when both env vars are set — ARDL_DEBUG_ESSENTIALS_DIR alone still gets you
            // just the builder-source dump (including its own heuristic candidateHelperNames list,
            // a starting point for deciding what to pass here) at zero extra cost.
            var chaseHelperNames = Environment.GetEnvironmentVariable("ARDL_CHASE_HELPER_NAMES");
            if (!string.IsNullOrEmpty(chaseHelperNames))
            {
                var names = chaseHelperNames.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
                logger.LogInformation("    portal: chasing {Count} helper name(s) across loaded scripts: {Names}",
                    names.Length, string.Join(", ", names));
                var chaseJson = await FieldBindingInvestigator.ChaseHelpersAsync(_page, names);
                await File.WriteAllTextAsync(Path.Combine(debugDir, $"{safeName}.helper-chase.json"), chaseJson);
            }
        }

        var notices = await BannerExtractor.ExtractAsync(_page);
        if (notices.Count > 0)
        {
            logger.LogInformation("    portal: found {Count} banner notice(s) on the page", notices.Count);
        }

        var fields = await EssentialsExtractor.ExtractAsync(_page, logger, captureTimeoutMultiplier);
        if (fields.Count == 0)
        {
            logger.LogWarning("    portal: extracted 0 Essentials field(s) for '{ResourceName}'", resourceName);
        }
        else
        {
            logger.LogInformation("    portal: extracted {Count} Essentials field(s)", fields.Count);
        }

        return new PortalCaptureResult(bytes, notices, fields);
    }

    public async ValueTask DisposeAsync()
    {
        await _context.DisposeAsync();
        await _browser.DisposeAsync();
        _playwright.Dispose();
        _captureLock.Dispose();
    }
}
