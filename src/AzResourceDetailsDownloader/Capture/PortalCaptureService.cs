using Microsoft.Extensions.Logging;
using Microsoft.Playwright;

namespace AzResourceDetailsDownloader.Capture;

public sealed class PortalCaptureService : IAsyncDisposable
{
    private readonly IPlaywright _playwright;
    private readonly IBrowser _browser;
    private readonly IBrowserContext _context;
    private readonly IPage _page;
    private readonly string _portalBaseUrl;
    private readonly string _tenantId;
    private readonly ILogger _logger;

    private PortalCaptureService(
        IPlaywright playwright, IBrowser browser, IBrowserContext context, IPage page,
        string portalBaseUrl, string tenantId, ILogger logger)
    {
        _playwright = playwright;
        _browser = browser;
        _context = context;
        _page = page;
        _portalBaseUrl = portalBaseUrl;
        _tenantId = tenantId;
        _logger = logger;
    }

    public static async Task<PortalCaptureService> CreateAsync(
        string portalBaseUrl, string tenantId, string storageStatePath, ILogger logger, bool headless = true)
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

        return new PortalCaptureService(playwright, browser, context, page, portalBaseUrl, tenantId, logger);
    }

    private static readonly TimeSpan HardCaptureTimeout = TimeSpan.FromSeconds(90);

    public async Task<byte[]> CaptureAsync(string resourceId, string resourceName, CancellationToken ct = default)
    {
        // Belt-and-suspenders: StableRenderWaiter already bounds its own waits, but this hard ceiling
        // guarantees one stuck capture can never stall the whole batch, whatever the root cause turns
        // out to be. Navigating the shared page to the next resource's URL implicitly abandons whatever
        // this call left in flight.
        var captureTask = CaptureCoreAsync(resourceId, resourceName, ct);
        var timeoutTask = Task.Delay(HardCaptureTimeout, ct);

        var winner = await Task.WhenAny(captureTask, timeoutTask);
        if (winner == timeoutTask)
        {
            throw new TimeoutException(
                $"Portal capture for '{resourceId}' ('{resourceName}') did not complete within {HardCaptureTimeout.TotalSeconds}s.");
        }

        return await captureTask;
    }

    private async Task<byte[]> CaptureCoreAsync(string resourceId, string resourceName, CancellationToken ct)
    {
        var url = PortalUrlBuilder.BuildOverviewUrl(_portalBaseUrl, _tenantId, resourceId);
        _logger.LogInformation("    portal: navigating to {Url}", url);
        await _page.GotoAsync(url, new PageGotoOptions { WaitUntil = WaitUntilState.DOMContentLoaded });

        _logger.LogInformation("    portal: navigation complete, waiting for stable render");
        await StableRenderWaiter.WaitForStableRenderAsync(_page, resourceName, _logger, ct);

        _logger.LogInformation("    portal: render stable, taking screenshot");
        var bytes = await _page.ScreenshotAsync(new PageScreenshotOptions { FullPage = true });
        _logger.LogInformation("    portal: screenshot captured ({Bytes} bytes)", bytes.Length);
        return bytes;
    }

    public async ValueTask DisposeAsync()
    {
        await _context.DisposeAsync();
        await _browser.DisposeAsync();
        _playwright.Dispose();
    }
}
