using Microsoft.Playwright;

namespace AzResourceDetailsDownloader.Capture;

public sealed record PortalField(string Label, string Value);

// Extracts the Azure Portal Overview blade's "Essentials" panel — the label/value grid Azure
// itself chooses to summarize a resource with (Resource group, Location, SKU, and type-specific
// fields like "Vault URI" or "Login server"). This is Azure's own answer to "which fields matter
// for this resource type", captured as structured data instead of pixels.
//
// Live-observed (2026-08-14): the Overview blade renders inside a cross-origin sandbox iframe
// (`*.reactblade.portal.azure.net`, named "ResourceOverview.ReactView") — a real Azure Portal
// architecture change, not a selector rename. `document.querySelectorAll` from the top-level frame
// can never see into a cross-origin iframe (a browser security boundary, not a bug) even though the
// content is fully rendered and visible in the screenshot — confirmed by checking every iframe's
// src/reachability live rather than guessing. Extraction goes through Playwright's `IFrameLocator`,
// which operates at the browser-automation layer and isn't subject to that restriction — confirmed
// by pulling the frame's real innerHTML through it (also cross-origin-safe) rather than assuming.
//
// The class names inside changed in the same redesign: `fxc-essentials-item` / `-label` / `-value`
// became `essentialsItem-NNN` / `essentialsLabel-NNN` / `essentialsValue-NNN`, where NNN looks like
// a per-render element-timing id, not a stable identifier — matched as a substring
// (`[class*="essentialsItem-"]`), not an exact class, so a different NNN on a different render/type
// doesn't break the selector. Falls back to the pre-2026-08-14 `fxc-essentials-*` classes on the
// top-level page if neither the sandbox iframe nor the new classes are found, in case a future
// portal build reverts or a blade type renders differently.
public static class EssentialsExtractor
{
    // Labels that are portal navigation/action chrome — never resource data — but render inside
    // an essentials item just like real fields, so the DOM selector alone can't tell them apart.
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

    // Name observed live on the Overview blade's sandbox iframe. Matched with a "starts with"
    // selector (`^=`), not an exact match, in case the numeric/session suffix portion of the name
    // varies by blade type or portal build.
    private const string OverviewSandboxIframeSelector = "iframe[name^='ResourceOverview']";

    private const string CurrentItemSelector = "[class*=\"essentialsItem-\"]";
    private const string LegacyItemSelector = ".fxc-essentials-item";

    // `title` is tried first (Fluent UI can pad/truncate visible text for layout while `title` holds
    // the untruncated string), then `innerText` — deliberately NOT `textContent`: the value wrapper
    // contains a second, hidden, ARIA/tooltip copy of the same link (`hidden` attribute, off-screen),
    // and `textContent` includes hidden-element text while `innerText` respects rendered visibility,
    // so `textContent` alone would silently duplicate every value ("rg-foorg-foo"). Live-caught by
    // inspecting the real value markup, not assumed.
    private static string BuildExtractItemsJs(string labelSelector, string valueSelector) => $$"""
        (elements) => {
            // Strips Unicode Private Use Area codepoints (0xE000-0xF8FF) before collapsing
            // whitespace -- Fluent UI's icon font (e.g. a "copy to clipboard" glyph sitting right
            // after the value text) renders as a PUA character, and innerText includes it as if it
            // were real text. Live-caught: every value came back with a trailing icon-glyph
            // character until this was added. Filtered by numeric code-point comparison, not a
            // regex Unicode escape, to avoid any encoding mangling of the escape sequence itself.
            const stripIcons = s => Array.from(s || '').filter(ch => {
                const code = ch.codePointAt(0);
                return !(code >= 0xE000 && code <= 0xF8FF);
            }).join('');
            const clean = s => stripIcons(s).replace(/\s+/g, ' ').trim();
            const textOf = el => clean(el.getAttribute('title') || el.innerText || el.textContent);
            return elements.map(item => {
                const labelEl = item.querySelector('{{labelSelector}}');
                if (!labelEl) return null;
                const label = textOf(labelEl);
                const valueEls = Array.from(item.querySelectorAll('{{valueSelector}}'));
                const value = valueEls.map(textOf).filter(v => v.length > 0).join(', ');
                return [label, value];
            }).filter(pair => pair && pair[0] && pair[1]);
        }
        """;

    private static readonly string CurrentExtractItemsJs =
        BuildExtractItemsJs("[class*=\"essentialsLabel-\"]", "[class*=\"essentialsValue-\"]");
    private static readonly string LegacyExtractItemsJs =
        BuildExtractItemsJs(".fxc-essentials-label", ".fxc-essentials-value");

    // Live-observed (2026-08-13): a capture taken right as StableRenderWaiter's loading-indicator wait timed
    // out (page not fully settled) produced a real screenshot but zero Essentials fields — the panel can
    // lag slightly behind the generic loading-indicator-clear signal. Wait specifically for the panel itself
    // to appear before extracting, rather than trusting the caller's generic render-stable signal alone.
    private static readonly TimeSpan EssentialsAppearTimeout = TimeSpan.FromSeconds(15);

    public static async Task<IReadOnlyList<PortalField>> ExtractAsync(IPage page)
    {
        try
        {
            var sandboxFrame = page.FrameLocator(OverviewSandboxIframeSelector);
            var fields = await TryExtractFromLocatorAsync(
                sandboxFrame.Locator(CurrentItemSelector), CurrentExtractItemsJs);
            if (fields.Count > 0)
            {
                return Finalize(fields);
            }

            // Sandbox iframe present but new classes not found there (unexpected, but cheap to try) —
            // or no sandbox iframe at all. Either way, try every remaining combination before giving
            // up: current classes on the top-level page, then legacy classes in the sandbox frame,
            // then legacy classes on the top-level page (the original, pre-2026-08-14 path).
            fields = await TryExtractFromLocatorAsync(page.Locator(CurrentItemSelector), CurrentExtractItemsJs);
            if (fields.Count > 0)
            {
                return Finalize(fields);
            }

            fields = await TryExtractFromLocatorAsync(sandboxFrame.Locator(LegacyItemSelector), LegacyExtractItemsJs);
            if (fields.Count > 0)
            {
                return Finalize(fields);
            }

            fields = await TryExtractFromLocatorAsync(page.Locator(LegacyItemSelector), LegacyExtractItemsJs);
            return Finalize(fields);
        }
        catch
        {
            // Best-effort: a missing/changed Essentials panel shouldn't fail the whole capture —
            // the screenshot and raw ARM JSON remain the authoritative artifacts either way.
            return [];
        }
    }

    private static async Task<List<PortalField>> TryExtractFromLocatorAsync(ILocator items, string extractJs)
    {
        try
        {
            await items.First.WaitForAsync(new LocatorWaitForOptions { Timeout = (float)EssentialsAppearTimeout.TotalMilliseconds });
        }
        catch (TimeoutException)
        {
            return [];
        }
        catch (PlaywrightException)
        {
            // The target frame itself doesn't exist (e.g. no sandbox iframe on this blade type) —
            // WaitForAsync against a non-existent frame throws rather than timing out.
            return [];
        }

        var rows = await items.EvaluateAllAsync<string?[][]>(extractJs);
        return rows
            .Where(r => r.Length == 2 && !string.IsNullOrWhiteSpace(r[0]) && !string.IsNullOrWhiteSpace(r[1]))
            .Select(r => new PortalField(r[0]!.Trim(), r[1]!.Trim()))
            .ToList();
    }

    private static List<PortalField> Finalize(List<PortalField> fields) =>
        fields
            .Where(f => !ChromeLabels.Contains(f.Label))
            // The portal can render an item twice during certain transitions (e.g. move-target
            // pickers); de-dupe by label, keeping the first occurrence.
            .DistinctBy(f => f.Label, StringComparer.OrdinalIgnoreCase)
            .ToList();

    // Kept permanently (not scaffolding to be deleted) — dumps the DOM region around the
    // "Essentials" landmark for inspecting the real markup when the extractor above needs
    // adjusting for a portal UI change or an unusual blade layout. No-op unless
    // ARDL_DEBUG_ESSENTIALS_DIR is set; see PortalCaptureService and AGENT.md. Frame-aware since
    // the 2026-08-14 sandbox-iframe change: dumps the sandbox frame's body via Playwright's
    // Locator API (cross-origin-safe) when present, the top-level page otherwise.
    public static async Task DumpDebugHtmlAsync(IPage page, string outputPath)
    {
        try
        {
            string html;
            var sandboxBody = page.FrameLocator(OverviewSandboxIframeSelector).Locator("body");
            try
            {
                await sandboxBody.WaitForAsync(new LocatorWaitForOptions { Timeout = 3000 });
                html = "<!-- dumped from inside the ResourceOverview sandbox iframe -->\n" + await sandboxBody.InnerHTMLAsync();
            }
            catch (TimeoutException)
            {
                html = "<!-- no ResourceOverview sandbox iframe found; dumped from the top-level page -->\n"
                    + await page.EvaluateAsync<string>("() => document.body.innerHTML");
            }

            Directory.CreateDirectory(Path.GetDirectoryName(outputPath)!);
            await File.WriteAllTextAsync(outputPath, html);
        }
        catch (Exception ex)
        {
            await File.WriteAllTextAsync(outputPath, $"<!-- extraction failed: {ex.Message} -->");
        }
    }
}
