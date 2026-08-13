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

    public async Task<PortalCaptureResult> CaptureAsync(string resourceId, string resourceName, ILogger logger, CancellationToken ct = default)
    {
        // Queueing for the lock is unbounded on purpose — it just means another unit's screenshot is in
        // progress, not that anything is stuck. The hard timeout below only starts counting once this
        // unit actually has the page to itself.
        await _captureLock.WaitAsync(ct);
        try
        {
            // Belt-and-suspenders: StableRenderWaiter already bounds its own waits, but this hard ceiling
            // guarantees one stuck capture can never stall the whole batch, whatever the root cause turns
            // out to be. Navigating the shared page to the next resource's URL implicitly abandons whatever
            // this call left in flight.
            var captureTask = CaptureCoreAsync(resourceId, resourceName, logger, ct);
            var timeoutTask = Task.Delay(HardCaptureTimeout, ct);

            var winner = await Task.WhenAny(captureTask, timeoutTask);
            if (winner == timeoutTask)
            {
                throw new TimeoutException(
                    $"Portal capture for '{resourceId}' ('{resourceName}') did not complete within {HardCaptureTimeout.TotalSeconds}s.");
            }

            return await captureTask;
        }
        finally
        {
            _captureLock.Release();
        }
    }

    private async Task<PortalCaptureResult> CaptureCoreAsync(string resourceId, string resourceName, ILogger logger, CancellationToken ct)
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
        }

        var notices = await BannerExtractor.ExtractAsync(_page);
        if (notices.Count > 0)
        {
            logger.LogInformation("    portal: found {Count} banner notice(s) on the page", notices.Count);
        }

        var fields = await EssentialsExtractor.ExtractAsync(_page);
        logger.LogInformation("    portal: extracted {Count} Essentials field(s)", fields.Count);

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
