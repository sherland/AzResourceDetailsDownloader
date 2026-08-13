using Microsoft.Playwright;

namespace AzResourceDetailsDownloader.Capture;

public sealed record PortalField(string Label, string Value);

// Extracts the Azure Portal Overview blade's "Essentials" panel — the label/value grid Azure
// itself chooses to summarize a resource with (Resource group, Location, SKU, and type-specific
// fields like "Vault URI" or "Login server"). This is Azure's own answer to "which fields matter
// for this resource type", captured as structured data instead of pixels.
//
// Selector found by live DOM inspection (Microsoft.KeyVault/vaults, 2026-08-13), not guessed —
// same practice as BannerExtractor. Each field renders as a `div.fxc-essentials-item` containing
// a `label.fxc-essentials-label` (clean text in the `title` attribute) and one or more
// `.fxc-essentials-value` elements (also `title`-bearing; some values are `<a>` links, e.g.
// Resource group, others are plain `<div>`s, e.g. Location — both carry the same class and
// `title` attribute). Multiple value elements per item (e.g. a multi-entry Tags field) are
// joined with ", ". The `title` attribute is preferred over `textContent` because Fluent UI can
// pad/truncate the visible text for layout while `title` holds the untruncated string — the same
// reasoning that made BannerExtractor prefer `aria-label` over visible text nodes.
public static class EssentialsExtractor
{
    // Labels that are portal navigation/action chrome — never resource data — but render inside
    // .fxc-essentials-item just like real fields, so the DOM selector alone can't tell them apart.
    // Identified by manual inspection of the values they actually carry (2026-08-13): "Click here to
    // manage keys", "Show firewall settings", "https://aka.ms/asrs/faq", etc. — action prompts and
    // doc links, not anything captured elsewhere in the resource's own ARM body. If a resource type
    // ever needs a *different* field that happens to share one of these labels, that's a portal UI
    // collision worth investigating on its own, not a reason to remove the label from this set.
    private static readonly HashSet<string> ChromeLabels = new(StringComparer.OrdinalIgnoreCase)
    {
        "Getting started", "Manage keys", "ADR namespace", "Management services", "Networking",
        "Topology", "Troubleshooting Guide", "FAQs", "Connection strings", "Keys",
        "Best practices", "New features", "OTLP connection info",
    };

    private const string ExtractEssentialsJs = @"() => {
        const clean = s => (s || '').replace(/\s+/g, ' ').trim();
        return Array.from(document.querySelectorAll('.fxc-essentials-item')).map(item => {
            const labelEl = item.querySelector('.fxc-essentials-label');
            if (!labelEl) return null;
            const label = clean(labelEl.getAttribute('title') || labelEl.textContent);
            const valueEls = Array.from(item.querySelectorAll('.fxc-essentials-value'));
            const value = valueEls
                .map(el => clean(el.getAttribute('title') || el.textContent))
                .filter(v => v.length > 0)
                .join(', ');
            return [label, value];
        }).filter(pair => pair && pair[0] && pair[1]);
    }";

    // Live-observed (2026-08-13): a capture taken right as StableRenderWaiter's loading-indicator wait timed
    // out (page not fully settled) produced a real screenshot but zero Essentials fields — the panel can
    // lag slightly behind the generic loading-indicator-clear signal. Wait specifically for the panel itself
    // to appear before extracting, rather than trusting the caller's generic render-stable signal alone.
    private static readonly TimeSpan EssentialsAppearTimeout = TimeSpan.FromSeconds(10);

    public static async Task<IReadOnlyList<PortalField>> ExtractAsync(IPage page)
    {
        try
        {
            try
            {
                await page.Locator(".fxc-essentials-item").First
                    .WaitForAsync(new LocatorWaitForOptions { Timeout = (float)EssentialsAppearTimeout.TotalMilliseconds });
            }
            catch (TimeoutException)
            {
                // Genuinely no Essentials panel on this blade type (or the portal changed) — fall through to
                // the extraction below, which will correctly return an empty list rather than throw.
            }

            var rows = await page.EvaluateAsync<string?[][]>(ExtractEssentialsJs);
            return rows
                .Where(r => r.Length == 2 && !string.IsNullOrWhiteSpace(r[0]) && !string.IsNullOrWhiteSpace(r[1]))
                .Select(r => new PortalField(r[0]!.Trim(), r[1]!.Trim()))
                .Where(f => !ChromeLabels.Contains(f.Label))
                // The portal can render an item twice during certain transitions (e.g. move-target
                // pickers); de-dupe by label, keeping the first occurrence.
                .DistinctBy(f => f.Label, StringComparer.OrdinalIgnoreCase)
                .ToList();
        }
        catch
        {
            // Best-effort: a missing/changed Essentials panel shouldn't fail the whole capture —
            // the screenshot and raw ARM JSON remain the authoritative artifacts either way.
            return [];
        }
    }

    // Kept permanently (not scaffolding to be deleted) — dumps the DOM region around the
    // "Essentials" landmark for inspecting the real markup when the extractor above needs
    // adjusting for a portal UI change or an unusual blade layout. No-op unless
    // ARDL_DEBUG_ESSENTIALS_DIR is set; see PortalCaptureService and AGENT.md.
    public static async Task DumpDebugHtmlAsync(IPage page, string outputPath)
    {
        try
        {
            var html = await page.EvaluateAsync<string>(@"() => {
                const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
                let node;
                while ((node = walker.nextNode())) {
                    if (node.textContent && node.textContent.trim() === 'Essentials') {
                        let el = node.parentElement;
                        for (let i = 0; i < 6 && el.parentElement; i++) {
                            el = el.parentElement;
                        }
                        return el.outerHTML;
                    }
                }
                return '<!-- Essentials landmark not found -->' + document.body.innerHTML.slice(0, 5000);
            }");

            Directory.CreateDirectory(Path.GetDirectoryName(outputPath)!);
            await File.WriteAllTextAsync(outputPath, html);
        }
        catch (Exception ex)
        {
            await File.WriteAllTextAsync(outputPath, $"<!-- extraction failed: {ex.Message} -->");
        }
    }
}
