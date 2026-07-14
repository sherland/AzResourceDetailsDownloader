using Microsoft.Extensions.Logging;
using Microsoft.Playwright;

namespace AzResourceDetailsDownloader.Capture;

public static class LoginBootstrap
{
    public static async Task RunAsync(string portalBaseUrl, string storageStatePath, ILogger logger, CancellationToken ct = default)
    {
        using var playwright = await Playwright.CreateAsync();
        await using var browser = await playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions
        {
            Headless = false,
            Args = ["--start-maximized", "--window-position=0,0"]
        });
        // ViewportSize = null ("no viewport") lets the page fill whatever size the actual OS window ends up,
        // instead of forcing a fixed content size that can exceed the real screen and push the window out of view.
        await using var context = await browser.NewContextAsync(new BrowserNewContextOptions
        {
            ViewportSize = null
        });
        var page = await context.NewPageAsync();

        logger.LogInformation("Opening {Url} — please log in (including MFA) in the browser window that just opened.", portalBaseUrl);
        await page.GotoAsync(portalBaseUrl);

        logger.LogInformation("Waiting for login to complete (up to 5 minutes)...");
        await WaitForLoginAsync(page, TimeSpan.FromMinutes(5), ct);

        var directory = Path.GetDirectoryName(storageStatePath);
        if (!string.IsNullOrEmpty(directory))
        {
            Directory.CreateDirectory(directory);
        }

        await context.StorageStateAsync(new BrowserContextStorageStateOptions { Path = storageStatePath });
        logger.LogInformation("Saved session state to {Path}. You can close the browser window now.", storageStatePath);
    }

    private static async Task WaitForLoginAsync(IPage page, TimeSpan timeout, CancellationToken ct)
    {
        var deadline = DateTime.UtcNow + timeout;
        while (DateTime.UtcNow < deadline)
        {
            ct.ThrowIfCancellationRequested();

            if (Uri.TryCreate(page.Url, UriKind.Absolute, out var uri)
                && uri.Host.Equals("portal.azure.com", StringComparison.OrdinalIgnoreCase)
                && !string.IsNullOrEmpty(uri.Fragment))
            {
                return;
            }

            await Task.Delay(TimeSpan.FromSeconds(2), ct);
        }

        throw new TimeoutException("Timed out waiting for interactive portal login to complete.");
    }
}
