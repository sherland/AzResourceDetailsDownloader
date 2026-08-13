using Microsoft.Playwright;

namespace AzResourceDetailsDownloader.Capture;

public sealed record PortalField(string Label, string Value);

// Extracts the Azure Portal Overview blade's "Essentials" panel — the label/value grid Azure
// itself chooses to summarize a resource with (Resource group, Location, SKU, and type-specific
// fields like "Vault URI" or "Login server"). This is Azure's own answer to "which fields matter
// for this resource type", captured as structured data instead of pixels.
//
// Live-observed (2026-08-14): the Overview blade renders inside a cross-origin sandbox iframe
// (`*.reactblade.portal.azure.net`) — a real Azure Portal architecture change, not a selector
// rename. The iframe's `name` is per-blade-type ("PublicIpAddress.ReactView", "ResourceOverview.
// ReactView", etc.), not a stable constant — matched instead by the `fxs-reactview-frame-active`
// class every active blade content frame carries, which the sibling extension/side-panel iframe
// (`fxs-extension-frame`) never does. `document.querySelectorAll` from the top-level frame
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
// doesn't break the selector.
//
// Live-observed (2026-08-14, second pass — after fixing the iframe selector above, a 60-type batch
// still extracted 0 fields for 44/48 successful captures): the `essentialsItem-NNN` grid is only ONE
// of (at least) two live layouts inside the sandbox iframe. Many blade types (Public IP confirmed;
// most `Microsoft.Network/*` types by inference) instead render each field as a Fluent UI
// `AccordionPanel` with a `PropertyField*-label` element paired to its value via `aria-labelledby`,
// not via a shared item-container class at all — the two layouts require genuinely different
// extraction logic, not just a different selector. Confirmed by dumping the live sandbox-frame body
// for a failing capture and finding real, fully-rendered "Resource group" / "Location" content under
// `id="PropertyField...-label"`, present from the very first snapshot (no render-lag involved — an
// earlier theory that the panel just needed a longer wait was disproven by this same dump: the
// content was already there, just under a selector the extractor didn't know about). Falls back to
// the pre-2026-08-14 `fxc-essentials-*` classes on the top-level page if none of the above are found,
// in case a future portal build reverts or a blade type renders differently again.
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

    // Unlike ChromeLabels above, these are values, not labels — the same field ("Tags",
    // "Container registries", "Fleet Manager", a description box, ...) is a legitimate field with
    // real data on a populated resource, but every capture in this tool's corpus is a
    // freshly-provisioned, empty/default-state resource, so it renders as the portal's own
    // empty-state action prompt instead ("Add tags", "Attach a registry", ...) — never anything
    // traceable to the resource's own ARM body, and actively misleading if baked into a reusable
    // template as if it were representative resource data. Live-observed across the 2026-08-14
    // 60-type backfill batch (also caught a same-shaped extraction glitch on SQL job agents, where
    // "Tags"' value came back as the literal string "Tags" instead of any placeholder text at all).
    private static readonly HashSet<string> ChromeValues = new(StringComparer.OrdinalIgnoreCase)
    {
        "Add tags", "Tags", "Attach a registry", "Click here to assign", "Configure",
        "Click here to add a description",
    };

    // Live-observed (2026-08-14, after the bulk 60-type backfill batch): the sandbox iframe's
    // `name` attribute is NOT a stable "ResourceOverview.ReactView" constant — it's per-blade-type
    // ("PublicIpAddress.ReactView" for a Public IP, etc.). Matching on `name^='ResourceOverview'`
    // only worked for the handful of types that happen to use that literal name (e.g. Managed
    // Identity) and silently extracted 0 fields for everything else — 44 of 48 successful captures
    // in that batch, caught only by noticing `git status` showed no portal-fields.json diff for
    // most of them. Fixed by matching the frame's `class`, not its `name`: every blade's active
    // React content frame carries `fxs-reactview-frame-active` regardless of resource type, while
    // the sibling extension/side-panel frame (`fxs-extension-frame`) never does — confirmed by
    // dumping the live iframe list for a failing capture (Public IP) rather than guessing.
    private const string OverviewSandboxIframeSelector = "iframe.fxs-reactview-frame-active";

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
            // Live-observed (2026-08-14): some labels (Resource group, Subscription) carry a nested
            // "(move)" action link right after the label text, and Tags carries a nested "(edit)"
            // one — `title`/`innerText`/`textContent` all fold that nested link's text into the
            // label ("Resource group (move)"). The wrapping markup isn't consistent (sometimes the
            // parens sit as the label's own direct text siblings around the link, sometimes the
            // whole "Tags (edit)" chunk is wrapped in its own nested div with no direct text of its
            // own at the outer level) — a plain "direct children only" text collection catches one
            // shape but not the other. Walking the subtree in document order and stopping at the
            // first <a>/<button> handles both, then a trailing dangling "(" (the open paren that
            // preceded the now-excluded link) is stripped as leftover wrapper punctuation.
            const labelTextOf = el => {
                let text = '';
                let stopped = false;
                const walk = node => {
                    for (const child of node.childNodes) {
                        if (stopped) return;
                        if (child.nodeType === Node.TEXT_NODE) {
                            text += child.textContent;
                        } else if (child.nodeType === Node.ELEMENT_NODE) {
                            if (child.tagName === 'A' || child.tagName === 'BUTTON') {
                                stopped = true;
                                return;
                            }
                            walk(child);
                        }
                    }
                };
                walk(el);
                return clean(text).replace(/\(\s*$/, '').trim() || textOf(el);
            };
            return elements.map(item => {
                const labelEl = item.querySelector('{{labelSelector}}');
                if (!labelEl) return null;
                const label = labelTextOf(labelEl);
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

    // The Fluent UI `PropertyField*-label` id suffix (`fui-rf`, `fui-rg`, ...) is a React `useId()`
    // value, unstable across renders just like the `essentialsItem-NNN` suffix — matched as a prefix/
    // suffix pair (`[id^="PropertyField"][id$="-label"]`), not an exact id. Label and value are NOT
    // siblings under a shared item container here (unlike the grid layout above); they're linked
    // semantically via `aria-labelledby`, so extraction starts from the label elements themselves and
    // looks up each value independently rather than querying within a shared parent.
    private const string PropertyFieldLabelSelector = "[id^=\"PropertyField\"][id$=\"-label\"]";

    private static readonly string PropertyFieldExtractItemsJs = $$"""
        (labels) => {
            const stripIcons = s => Array.from(s || '').filter(ch => {
                const code = ch.codePointAt(0);
                return !(code >= 0xE000 && code <= 0xF8FF);
            }).join('');
            const clean = s => stripIcons(s).replace(/\s+/g, ' ').trim();
            const textOf = el => clean(el.getAttribute('title') || el.innerText || el.textContent);
            // Walks the label subtree in document order, stopping at the first <a>/<button> --
            // excludes a nested "(move)" action link some labels (Resource group, Subscription)
            // carry right after the label text, which `textContent`/`innerText` would otherwise
            // fold into the label itself. Trailing dangling "(" left over from the excluded link's
            // wrapper punctuation is stripped afterward.
            const labelTextOf = el => {
                let text = '';
                let stopped = false;
                const walk = node => {
                    for (const child of node.childNodes) {
                        if (stopped) return;
                        if (child.nodeType === Node.TEXT_NODE) {
                            text += child.textContent;
                        } else if (child.nodeType === Node.ELEMENT_NODE) {
                            if (child.tagName === 'A' || child.tagName === 'BUTTON') {
                                stopped = true;
                                return;
                            }
                            walk(child);
                        }
                    }
                };
                walk(el);
                return clean(text).replace(/\(\s*$/, '').trim() || textOf(el);
            };
            return labels.map(labelEl => {
                const label = labelTextOf(labelEl);
                if (!label || !labelEl.id) return null;
                const valueEl = document.querySelector(`[aria-labelledby="${labelEl.id}"]`);
                if (!valueEl) return null;
                const value = textOf(valueEl);
                return [label, value];
            }).filter(pair => pair && pair[0] && pair[1]);
        }
        """;

    // Live-observed (2026-08-14, third pass — after fixing the two layouts above, 4 of 60 backfilled
    // types still extracted 0 fields): those 4 (Portal/dashboards confirmed by dumping; querypacks,
    // privateDnsZones/virtualNetworkLinks, and DataProtection/backupVaults inferred to be the same
    // case) don't have a custom Overview blade extension at all — the sandbox iframe is named
    // "ResourceProperties.ReactView", not an Overview variant, and instead renders Azure's generic
    // fallback "Properties" form: office-fabric `<label class="ms-Label" aria-label="...">` elements,
    // each paired to a readonly `<input>` via `aria-labelledby` (same pairing mechanism as the
    // PropertyField layout, but the value lives in the input's `.value` property, not its text).
    private const string PropertiesFormLabelSelector = "label.ms-Label[aria-label][id]";

    private static readonly string PropertiesFormExtractItemsJs = $$"""
        (labels) => {
            const stripIcons = s => Array.from(s || '').filter(ch => {
                const code = ch.codePointAt(0);
                return !(code >= 0xE000 && code <= 0xF8FF);
            }).join('');
            const clean = s => stripIcons(s).replace(/\s+/g, ' ').trim();
            const textOf = el => clean((el.value ?? el.getAttribute('title')) || el.innerText || el.textContent);
            return labels.map(labelEl => {
                const label = clean(labelEl.getAttribute('aria-label') || labelEl.textContent);
                if (!label || !labelEl.id) return null;
                const valueEl = document.querySelector(`[aria-labelledby="${labelEl.id}"]`);
                if (!valueEl) return null;
                const value = textOf(valueEl);
                return [label, value];
            }).filter(pair => pair && pair[0] && pair[1]);
        }
        """;

    // Live-observed (2026-08-13, top-level page era): a capture taken right as StableRenderWaiter's
    // loading-indicator wait timed out (page not fully settled) produced a real screenshot but zero
    // Essentials fields — the panel can lag slightly behind the generic loading-indicator-clear
    // signal. Wait specifically for the panel itself to appear before extracting, rather than
    // trusting the caller's generic render-stable signal alone.
    //
    // Live-observed again (2026-08-14): a suspected repeat of the same lag *inside* the sandbox
    // iframe turned out to be a red herring — a DOM dump taken well after a 40s dedicated wait still
    // showed 0 `essentialsItem-*` matches, but the same dump's raw HTML contained the real, fully-
    // rendered `PropertyField`-layout content (see below) present from the very first snapshot. The
    // content was never late; the selector was just wrong for that layout. Kept short: there's no
    // real-world evidence any combo needs more than a few seconds once it's the right one. Three
    // combos now share "primary" status (grid / PropertyField / Properties-form) — each keeps its own
    // moderate timeout rather than the original single-combo 15s, so the worst case (a blade type
    // matching none of them) doesn't approach PortalCaptureService's 90s HardCaptureTimeout once
    // screenshot + banner capture time is added on top.
    private static readonly TimeSpan PrimaryAppearTimeout = TimeSpan.FromSeconds(10);
    private static readonly TimeSpan FallbackAppearTimeout = TimeSpan.FromSeconds(5);

    public static async Task<IReadOnlyList<PortalField>> ExtractAsync(IPage page)
    {
        try
        {
            var sandboxFrame = page.FrameLocator(OverviewSandboxIframeSelector);

            var fields = await TryExtractFromLocatorAsync(
                sandboxFrame.Locator(CurrentItemSelector), CurrentExtractItemsJs, PrimaryAppearTimeout);
            if (fields.Count > 0)
            {
                return Finalize(fields);
            }

            fields = await TryExtractFromLocatorAsync(
                sandboxFrame.Locator(PropertyFieldLabelSelector), PropertyFieldExtractItemsJs, PrimaryAppearTimeout);
            if (fields.Count > 0)
            {
                return Finalize(fields);
            }

            fields = await TryExtractFromLocatorAsync(
                sandboxFrame.Locator(PropertiesFormLabelSelector), PropertiesFormExtractItemsJs, PrimaryAppearTimeout);
            if (fields.Count > 0)
            {
                return Finalize(fields);
            }

            // None of the sandbox-frame layouts matched (or there's no sandbox iframe at all) — try
            // every remaining combination before giving up: current classes on the top-level page,
            // then legacy classes in the sandbox frame, then legacy classes on the top-level page
            // (the original, pre-2026-08-14 path). None of these has ever been observed to be the
            // right combo once the two primaries above miss, so each gets only a short confirmatory
            // wait rather than repeating the full budget.
            fields = await TryExtractFromLocatorAsync(page.Locator(CurrentItemSelector), CurrentExtractItemsJs, FallbackAppearTimeout);
            if (fields.Count > 0)
            {
                return Finalize(fields);
            }

            fields = await TryExtractFromLocatorAsync(sandboxFrame.Locator(LegacyItemSelector), LegacyExtractItemsJs, FallbackAppearTimeout);
            if (fields.Count > 0)
            {
                return Finalize(fields);
            }

            fields = await TryExtractFromLocatorAsync(page.Locator(LegacyItemSelector), LegacyExtractItemsJs, FallbackAppearTimeout);
            return Finalize(fields);
        }
        catch
        {
            // Best-effort: a missing/changed Essentials panel shouldn't fail the whole capture —
            // the screenshot and raw ARM JSON remain the authoritative artifacts either way.
            return [];
        }
    }

    private static async Task<List<PortalField>> TryExtractFromLocatorAsync(ILocator items, string extractJs, TimeSpan timeout)
    {
        try
        {
            await items.First.WaitForAsync(new LocatorWaitForOptions { Timeout = (float)timeout.TotalMilliseconds });
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
            .Where(f => !ChromeValues.Contains(f.Value))
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
            // Lists every iframe's id/name/class/src straight from the top-level DOM (always
            // reachable, even cross-origin) before the frame-specific dump below — the fastest way
            // to see, live, which selector would actually match at capture time.
            var iframeList = await page.EvaluateAsync<string>("""
                () => Array.from(document.querySelectorAll('iframe')).map((f, i) =>
                    `iframe[${i}] id=${f.id} name=${f.name} class="${f.className}" src=${f.src}`
                ).join('\n')
                """);

            string html;
            var sandboxFrameForDump = page.FrameLocator(OverviewSandboxIframeSelector);
            var sandboxBody = sandboxFrameForDump.Locator("body");
            try
            {
                await sandboxBody.WaitForAsync(new LocatorWaitForOptions { Timeout = 3000 });
                html = "<!-- dumped from inside the sandbox iframe -->\n" + await sandboxBody.InnerHTMLAsync();
            }
            catch (Exception frameEx) when (frameEx is TimeoutException or PlaywrightException)
            {
                html = $"<!-- no sandbox iframe found ({frameEx.GetType().Name}: {frameEx.Message}); dumped from the top-level page -->\n"
                    + await page.EvaluateAsync<string>("() => document.body.innerHTML");
            }

            html = $"<!-- iframes:\n{iframeList}\n-->\n" + html;

            Directory.CreateDirectory(Path.GetDirectoryName(outputPath)!);
            await File.WriteAllTextAsync(outputPath, html);
        }
        catch (Exception ex)
        {
            await File.WriteAllTextAsync(outputPath, $"<!-- extraction failed: {ex.Message} -->");
        }
    }
}
