using Microsoft.Extensions.Logging;
using Microsoft.Playwright;

namespace AzResourceDetailsDownloader.Capture;

public sealed class PortalRenderException(string message) : Exception(message);

public static class StableRenderWaiter
{
    public static async Task WaitForStableRenderAsync(IPage page, string resourceName, ILogger logger, CancellationToken ct = default)
    {
        ThrowIfLoginRedirect(page.Url);

        var found = await TryWaitForContentAsync(page, resourceName);
        if (!found)
        {
            logger.LogWarning("Stable-render signal not found on first attempt for '{ResourceName}'; reloading once.", resourceName);
            await page.ReloadAsync(new PageReloadOptions { WaitUntil = WaitUntilState.DOMContentLoaded });
            ThrowIfLoginRedirect(page.Url);

            found = await TryWaitForContentAsync(page, resourceName);
            if (!found)
            {
                logger.LogWarning(
                    "Stable-render signal still not found for '{ResourceName}' after retry; capturing best-effort screenshot anyway.",
                    resourceName);
            }
        }

        await Task.Delay(TimeSpan.FromMilliseconds(1200), ct);
    }

    private static async Task<bool> TryWaitForContentAsync(IPage page, string resourceName)
    {
        try
        {
            await page.GetByText("Essentials", new PageGetByTextOptions { Exact = false })
                .First
                .WaitForAsync(new LocatorWaitForOptions { Timeout = 20000 });
            return true;
        }
        catch (TimeoutException)
        {
            try
            {
                await page.GetByRole(AriaRole.Heading, new PageGetByRoleOptions { Name = resourceName, Exact = false })
                    .First
                    .WaitForAsync(new LocatorWaitForOptions { Timeout = 10000 });
                return true;
            }
            catch (TimeoutException)
            {
                return false;
            }
        }
    }

    private static void ThrowIfLoginRedirect(string url)
    {
        if (url.Contains("login.microsoftonline.com", StringComparison.OrdinalIgnoreCase)
            || url.Contains("login.windows.net", StringComparison.OrdinalIgnoreCase))
        {
            throw new PortalRenderException(
                $"Portal navigation redirected to a login page ({url}) — the saved session has likely expired. Re-run with --login.");
        }
    }
}
