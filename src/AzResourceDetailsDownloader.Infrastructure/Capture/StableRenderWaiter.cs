using Microsoft.Extensions.Logging;
using Microsoft.Playwright;

namespace AzResourceDetailsDownloader.Capture;

public sealed class PortalRenderException(string message) : Exception(message);

public static class StableRenderWaiter
{
    // Fluent UI (which the portal is built on) marks in-progress content with these patterns regardless
    // of the specific blade. Confirmed by evidence, not assumption: a batch of live captures showed several
    // blades screenshotted mid-render with a visible 3-dot bouncing spinner, meaning the earlier version of
    // this check (which deliberately excluded "spinner" over false-positive worries) was missing exactly
    // the pattern that mattered. "spinner" and role="status" are included now on the strength of that
    // evidence — the bounded timeout below still caps the downside if a false positive ever occurs.
    private const string LoadingIndicatorSelector =
        "[role='progressbar'], [role='status'], [aria-busy='true'], [class*='shimmer' i], [class*='skeleton' i], [class*='spinner' i]";
    private static readonly TimeSpan LoadingIndicatorClearTimeout = TimeSpan.FromSeconds(15);
    private static readonly TimeSpan LoadingIndicatorPollInterval = TimeSpan.FromMilliseconds(300);

    // The portal can show a real "resource not found" 404 in the content panel while the blade *chrome*
    // (title bar) still renders the resource's name from the URL alone — so a heading match can be a false
    // positive here. Seen in practice on a resource fetched immediately after creation (an ARM-to-portal
    // propagation lag), distinct from the plain "still loading" case: it's worth more/longer retries than a
    // slow render, since it's fundamentally waiting on backend replication rather than a page finishing a
    // render it has already started.
    private const string NotFoundText = "The resource was not found";
    private static readonly TimeSpan[] NotFoundRetryDelays =
        [TimeSpan.FromSeconds(3), TimeSpan.FromSeconds(6), TimeSpan.FromSeconds(12)];

    // Scales every wait/timeout below proportionally — same pattern as EssentialsExtractor's
    // captureTimeoutMultiplier (see PortalCaptureService), added here for the same reason: without
    // it, exercising the fallback/timeout paths (heading not found, indicators never clear) in a
    // test means genuinely waiting out the real 20s/15s/etc. constants, since none of them were
    // otherwise adjustable. Defaults to 1.0 — zero change to today's production timing unless a
    // caller opts in, and PortalCaptureService doesn't (yet) pass anything else.
    public static async Task WaitForStableRenderAsync(
        IPage page, string resourceName, ILogger logger, CancellationToken ct = default, double timeoutMultiplier = 1.0)
    {
        ThrowIfLoginRedirect(page.Url);

        var found = await TryWaitForContentAsync(page, resourceName, timeoutMultiplier);
        if (!found)
        {
            logger.LogWarning("Stable-render signal not found on first attempt for '{ResourceName}'; reloading once.", resourceName);
            await page.ReloadAsync(new PageReloadOptions { WaitUntil = WaitUntilState.DOMContentLoaded });
            ThrowIfLoginRedirect(page.Url);

            found = await TryWaitForContentAsync(page, resourceName, timeoutMultiplier);
            if (!found)
            {
                logger.LogWarning(
                    "Stable-render signal still not found for '{ResourceName}' after retry; capturing best-effort screenshot anyway.",
                    resourceName);
                await LogDiagnosticsAsync(page, resourceName, logger);
            }
        }

        // Belt-and-suspenders on top of the content-marker check above: even once the heading/Essentials is
        // found, give any still-visible shimmer/spinner/progressbar a bounded window to clear before we
        // settle and screenshot, since these can outlive the initial content marker on some blades.
        await WaitForLoadingIndicatorsToClearAsync(page, resourceName, logger, timeoutMultiplier);

        await Task.Delay(TimeSpan.FromMilliseconds(1200 * timeoutMultiplier), ct);

        // Must run LAST, immediately before the caller takes the screenshot — not before the loading-indicator
        // wait above. The "not found" 404 is itself the page's *settled* state (it replaces the loading
        // spinner once the backend replies), so checking for it before the spinner has cleared can pass clean
        // even though the page goes on to resolve into "not found" moments later. Confirmed live: a retest of
        // Microsoft.Insights/activityLogAlerts logged no "not found" warning (the earlier-positioned check
        // passed) yet the saved screenshot still showed "The resource was not found" — the page transitioned
        // into that state during/after the indicator wait, after the once-only check had already passed.
        await EnsureNotResourceNotFoundAsync(page, resourceName, logger, ct, timeoutMultiplier);
    }

    private static async Task EnsureNotResourceNotFoundAsync(
        IPage page, string resourceName, ILogger logger, CancellationToken ct, double timeoutMultiplier)
    {
        for (var attempt = 0; attempt <= NotFoundRetryDelays.Length; attempt++)
        {
            var isNotFound = await page.GetByText(NotFoundText, new PageGetByTextOptions { Exact = false }).CountAsync() > 0;
            if (!isNotFound)
            {
                return;
            }

            if (attempt == NotFoundRetryDelays.Length)
            {
                throw new PortalRenderException(
                    $"Portal shows '{NotFoundText}' for '{resourceName}' after {NotFoundRetryDelays.Length} retries — " +
                    "likely an ARM-to-portal propagation delay that didn't clear in time, not a rendering-speed issue.");
            }

            logger.LogWarning(
                "  portal shows '{NotFoundText}' for '{ResourceName}' (ARM-to-portal propagation lag?); retrying in {Delay}s.",
                NotFoundText, resourceName, NotFoundRetryDelays[attempt].TotalSeconds);
            await Task.Delay(NotFoundRetryDelays[attempt] * timeoutMultiplier, ct);
            await page.ReloadAsync(new PageReloadOptions { WaitUntil = WaitUntilState.DOMContentLoaded });
            ThrowIfLoginRedirect(page.Url);
            await TryWaitForContentAsync(page, resourceName, timeoutMultiplier);
            // Reloading re-triggers the loading spinner, so give it the same chance to settle before the
            // next "not found" check at the top of this loop — otherwise this retry inherits the exact
            // check-too-early bug this method exists to fix.
            await WaitForLoadingIndicatorsToClearAsync(page, resourceName, logger, timeoutMultiplier);
        }
    }

    private static async Task<bool> TryWaitForContentAsync(IPage page, string resourceName, double timeoutMultiplier)
    {
        // The resource-name heading is checked FIRST and is the stronger signal: the whole batch reuses one
        // page/tab across every resource (by design, to avoid re-triggering MFA) and only the URL's hash
        // fragment changes between navigations, so the previous resource's "Essentials" text can still be
        // sitting in the DOM for a moment after a new navigation starts. A heading matching the NEW
        // resource's own (randomly-generated, effectively unique) name can't be satisfied by that stale
        // content, whereas "Essentials" alone can.
        try
        {
            await page.GetByRole(AriaRole.Heading, new PageGetByRoleOptions { Name = resourceName, Exact = false })
                .First
                .WaitForAsync(new LocatorWaitForOptions { Timeout = (float)(20000 * timeoutMultiplier) });
            return true;
        }
        catch (TimeoutException)
        {
            try
            {
                await page.GetByText("Essentials", new PageGetByTextOptions { Exact = false })
                    .First
                    .WaitForAsync(new LocatorWaitForOptions { Timeout = (float)(10000 * timeoutMultiplier) });
                return true;
            }
            catch (TimeoutException)
            {
                return false;
            }
        }
    }

    private static async Task WaitForLoadingIndicatorsToClearAsync(
        IPage page, string resourceName, ILogger logger, double timeoutMultiplier)
    {
        var scaledClearTimeout = LoadingIndicatorClearTimeout * timeoutMultiplier;
        var deadline = DateTime.UtcNow + scaledClearTimeout;
        while (DateTime.UtcNow < deadline)
        {
            int count;
            try
            {
                count = await page.Locator(LoadingIndicatorSelector).CountAsync();
            }
            catch
            {
                return; // page navigating/closing — nothing sensible to wait on.
            }

            if (count == 0)
            {
                return;
            }

            await Task.Delay(LoadingIndicatorPollInterval * timeoutMultiplier);
        }

        logger.LogWarning(
            "  loading indicators (progressbar/status/shimmer/skeleton/spinner) still visible for '{ResourceName}' after {Timeout}s; capturing anyway.",
            resourceName, scaledClearTimeout.TotalSeconds);
    }

    // Diagnostic for the rare case where even the content-marker retry is exhausted — helps root-cause any
    // future recurrence with evidence instead of guesswork.
    private static async Task LogDiagnosticsAsync(IPage page, string resourceName, ILogger logger)
    {
        try
        {
            var progressBars = await page.Locator("[role='progressbar']").CountAsync();
            var status = await page.Locator("[role='status']").CountAsync();
            var ariaBusy = await page.Locator("[aria-busy='true']").CountAsync();
            var shimmer = await page.Locator("[class*='shimmer' i]").CountAsync();
            var skeleton = await page.Locator("[class*='skeleton' i]").CountAsync();
            var spinner = await page.Locator("[class*='spinner' i]").CountAsync();
            var bodyText = await page.EvaluateAsync<string>("document.body.innerText");
            var sample = bodyText.Length > 300 ? bodyText[..300] : bodyText;

            logger.LogWarning(
                "    diag[{ResourceName}]: progressbar={ProgressBars} status={Status} aria-busy={AriaBusy} shimmer={Shimmer} skeleton={Skeleton} spinner={Spinner} bodyTextSample={Sample}",
                resourceName, progressBars, status, ariaBusy, shimmer, skeleton, spinner, sample.ReplaceLineEndings(" | "));
        }
        catch (Exception ex)
        {
            logger.LogWarning("    diag[{ResourceName}]: failed to collect diagnostics: {Error}", resourceName, ex.Message);
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
