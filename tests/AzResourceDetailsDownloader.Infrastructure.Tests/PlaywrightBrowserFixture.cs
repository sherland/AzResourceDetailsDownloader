using Microsoft.Playwright;

namespace AzResourceDetailsDownloader.Tests;

// Shared across every [Fact] in a test class via IClassFixture<T> — launching a headless Chromium
// takes real wall-clock time, so tests share one browser instance and each opens its own IPage
// rather than paying the launch cost per test. Requires Playwright's browser binaries to already be
// installed (`playwright.ps1 install --with-deps chromium` — see ci.yml); if they're missing,
// InitializeAsync throws a clear Playwright error rather than the test itself failing confusingly.
public sealed class PlaywrightBrowserFixture : IAsyncLifetime
{
    private IPlaywright _playwright = null!;
    public IBrowser Browser { get; private set; } = null!;

    public async Task InitializeAsync()
    {
        _playwright = await Playwright.CreateAsync();
        Browser = await _playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions { Headless = true });
    }

    public async Task DisposeAsync()
    {
        await Browser.DisposeAsync();
        _playwright.Dispose();
    }
}
