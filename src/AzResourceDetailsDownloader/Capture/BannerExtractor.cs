using Microsoft.Playwright;

namespace AzResourceDetailsDownloader.Capture;

// Azure Portal's info/warning/error boxes at the top of a blade (deprecation notices, security
// recommendations, breaking-change warnings — e.g. "Azure Cache for Redis new creation requests will be
// blocked starting October 1, 2026") render as a `div.fxc-infoBox-container` with `role="status"` and the
// full clean message in its `aria-label` (the visible text nodes inside can be truncated/duplicated for
// visual layout, so aria-label is the reliable source). Found by live DOM inspection, not guessed — two
// earlier guesses (role="alert", then role="banner", which turned out to be the page's own header landmark)
// were both wrong before walking the ancestor chain from known banner text found this.
public static class BannerExtractor
{
    public static async Task<IReadOnlyList<string>> ExtractAsync(IPage page)
    {
        var raw = await page.Locator("[class*='fxc-infoBox-container']")
            .EvaluateAllAsync<string?[]>("els => els.map(e => e.getAttribute('aria-label'))");

        return raw
            .OfType<string>()
            .Select(t => t.Trim())
            .Where(t => t.Length >= 20) // skip anything accidentally matched with no real message
            .Distinct()
            .ToList();
    }
}
