using AzResourceDetailsDownloader.Capture;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Playwright;

namespace AzResourceDetailsDownloader.Tests;

// Real-browser regression tests for StableRenderWaiter, same technique as
// EssentialsExtractorReplayTests: a real headless Chromium against small hand-authored HTML
// fixtures, calling the actual production WaitForStableRenderAsync.
//
// timeoutMultiplier exists specifically to make these tests possible without genuinely waiting out
// the real 20s/15s/etc. constants — see that parameter's own doc comment on StableRenderWaiter.
//
// Deliberately NOT covered here: the reload-retry paths (heading not found on the first attempt ->
// reload -> retry; the not-found-text retry loop). Checked first whether this was even feasible:
// page.ReloadAsync() against a page loaded via SetContentAsync navigates back to a genuinely blank
// about:blank (verified live — the body's text is empty afterward), not a re-render of the same
// fixture, so a reload-dependent scenario can't be simulated this way. Testing those paths properly
// would need a real local HTTP server so reload actually re-fetches the same fixture content — a
// bigger lift, left for later rather than silently skipped without a reason on record.
public sealed class StableRenderWaiterReplayTests(PlaywrightBrowserFixture fixture) : IClassFixture<PlaywrightBrowserFixture>
{
    private const double TestTimeoutMultiplier = 0.05;
    private const string ResourceName = "kv-example";

    private sealed class CapturingLogger : ILogger
    {
        public List<string> Warnings { get; } = [];

        public IDisposable? BeginScope<TState>(TState state) where TState : notnull => null;

        public bool IsEnabled(LogLevel logLevel) => true;

        public void Log<TState>(LogLevel logLevel, EventId eventId, TState state, Exception? exception, Func<TState, Exception?, string> formatter)
        {
            if (logLevel == LogLevel.Warning)
            {
                Warnings.Add(formatter(state, exception));
            }
        }
    }

    private async Task<IPage> NewPageWithContentAsync(string html)
    {
        var page = await fixture.Browser.NewPageAsync();
        await page.SetContentAsync(html);
        return page;
    }

    [Fact]
    public async Task WaitForStableRenderAsync_HeadingMatchesResourceName_CompletesWithoutThrowing()
    {
        var page = await NewPageWithContentAsync($"<html><body><h1>{ResourceName}</h1></body></html>");
        try
        {
            await StableRenderWaiter.WaitForStableRenderAsync(
                page, ResourceName, NullLogger.Instance, timeoutMultiplier: TestTimeoutMultiplier);
        }
        finally
        {
            await page.CloseAsync();
        }
    }

    // The whole reason the fallback exists: the batch reuses one page/tab across resources, so the
    // previous resource's "Essentials" text can briefly outlive the heading. A page whose heading
    // never matches falls all the way through the heading wait, then finds "Essentials" instead.
    [Fact]
    public async Task WaitForStableRenderAsync_HeadingAbsentButEssentialsTextPresent_FallsBackAndCompletes()
    {
        var page = await NewPageWithContentAsync(
            "<html><body><h1>Some Other Resource</h1><div>Essentials</div></body></html>");
        try
        {
            await StableRenderWaiter.WaitForStableRenderAsync(
                page, ResourceName, NullLogger.Instance, timeoutMultiplier: TestTimeoutMultiplier);
        }
        finally
        {
            await page.CloseAsync();
        }
    }

    [Fact]
    public async Task WaitForStableRenderAsync_NoLoadingIndicators_CompletesWithoutWarning()
    {
        var logger = new CapturingLogger();
        var page = await NewPageWithContentAsync($"<html><body><h1>{ResourceName}</h1></body></html>");
        try
        {
            await StableRenderWaiter.WaitForStableRenderAsync(
                page, ResourceName, logger, timeoutMultiplier: TestTimeoutMultiplier);

            Assert.Empty(logger.Warnings);
        }
        finally
        {
            await page.CloseAsync();
        }
    }

    // A loading indicator present at first but cleared shortly after (simulating a real render
    // finishing) must not trip the "still visible, capturing anyway" warning — the poll loop is
    // supposed to catch the clear and return early, not wait out the full timeout regardless.
    [Fact]
    public async Task WaitForStableRenderAsync_LoadingIndicatorClearsQuickly_CompletesWithoutWarning()
    {
        var logger = new CapturingLogger();
        var page = await NewPageWithContentAsync($"""
            <html><body>
              <h1>{ResourceName}</h1>
              <div role="progressbar" id="spinner"></div>
              <script>setTimeout(() => document.getElementById('spinner').remove(), 100);</script>
            </body></html>
            """);
        try
        {
            await StableRenderWaiter.WaitForStableRenderAsync(
                page, ResourceName, logger, timeoutMultiplier: TestTimeoutMultiplier);

            Assert.Empty(logger.Warnings);
        }
        finally
        {
            await page.CloseAsync();
        }
    }

    [Fact]
    public async Task WaitForStableRenderAsync_LoadingIndicatorNeverClears_TimesOutAndLogsWarningButStillCompletes()
    {
        var logger = new CapturingLogger();
        var page = await NewPageWithContentAsync($"""
            <html><body>
              <h1>{ResourceName}</h1>
              <div role="progressbar"></div>
            </body></html>
            """);
        try
        {
            await StableRenderWaiter.WaitForStableRenderAsync(
                page, ResourceName, logger, timeoutMultiplier: TestTimeoutMultiplier);

            Assert.Contains(logger.Warnings, w => w.Contains("still visible"));
        }
        finally
        {
            await page.CloseAsync();
        }
    }

    [Fact]
    public async Task WaitForStableRenderAsync_NoResourceNotFoundText_CompletesWithoutThrowing()
    {
        var page = await NewPageWithContentAsync($"<html><body><h1>{ResourceName}</h1><p>Overview</p></body></html>");
        try
        {
            // Would throw PortalRenderException if the (absent) "resource was not found" text were
            // ever misdetected — this is the negative-case check for that logic's happy path.
            await StableRenderWaiter.WaitForStableRenderAsync(
                page, ResourceName, NullLogger.Instance, timeoutMultiplier: TestTimeoutMultiplier);
        }
        finally
        {
            await page.CloseAsync();
        }
    }

    // ThrowIfLoginRedirect (the session-expiry guard) is NOT covered here: it checks page.Url
    // against known login-redirect hostnames, and SetContentAsync always leaves page.Url at
    // "about:blank" — there's no way to make it observe a login URL without either a real network
    // request or route interception standing in for one, which felt like a disproportionate amount
    // of test-infrastructure for one string.Contains check. Left as a known gap rather than a faked
    // test asserting nothing real.
}
