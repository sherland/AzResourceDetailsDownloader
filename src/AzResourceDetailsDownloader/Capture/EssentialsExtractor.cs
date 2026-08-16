using System.Text.RegularExpressions;
using Microsoft.Extensions.Logging;
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
    internal const string OverviewSandboxIframeSelector = "iframe.fxs-reactview-frame-active";

    private const string CurrentItemSelector = "[class*=\"essentialsItem-\"]";
    private const string LegacyItemSelector = ".fxc-essentials-item";

    // Live-found (2026-08-16, Microsoft.AnalysisServices/servers — a debug fiber dump via
    // DumpFiberBuilderSourceAsync came back "no anchor element found in this frame" for all three
    // combos above, confirming this type's Overview pane isn't routed through the shared
    // "Essentials" framework component at all): a fourth, distinct layout, apparently a
    // custom-built extension pane rather than framework-provided — literal (not per-render-suffixed)
    // class names `asx-overview-essentials__row` (item), `asx-overview-essentials__label` (label),
    // and either `asx-overview-essentials__value` or `asx-overview-essentials__status` (value; the
    // "Status" field alone uses the latter, e.g. `asx-overview-essentials__status--success`).
    // Confirmed via a raw HTML dump: 7 fields (Subscription name, Resource group, Status, Location,
    // Subscription ID, Server name, Management Server Name, Pricing tier) all fully rendered under
    // these classes from the very first snapshot, no render-lag involved. Substring-matched
    // (`[class*=...]`) since the value classes carry extra modifier suffixes
    // (`--interactive`, `--mono`, `--break`, `--success`) alongside the base name.
    private const string AsxItemSelector = ".asx-overview-essentials__row";

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
            //
            // Live-observed again (2026-08-14, AppConfiguration Standard tier — never seen before
            // because every earlier capture of this label was on the Free tier, which renders no
            // tooltip icon at all): "Geo-replication" carries a `TooltipHost`-wrapped info icon
            // instead of a plain `<a>`/`<button>` — a non-interactive tag (observed as a `<span>`
            // via the portal's own dumped source, `FontIcon`) but with `role="button"` set, whose
            // tooltip text ("Replicas allow for higher availability...") got folded straight into
            // the label ("Geo-replicationReplicas allow for..."). Tag-name checking alone can't
            // catch this — stop the walk on ARIA role="button" too, not just the two tag names.
            const labelTextOf = el => {
                let text = '';
                let stopped = false;
                const walk = node => {
                    for (const child of node.childNodes) {
                        if (stopped) return;
                        if (child.nodeType === Node.TEXT_NODE) {
                            text += child.textContent;
                        } else if (child.nodeType === Node.ELEMENT_NODE) {
                            if (child.tagName === 'A' || child.tagName === 'BUTTON'
                                || child.getAttribute('role') === 'button') {
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
    private static readonly string AsxExtractItemsJs = BuildExtractItemsJs(
        "[class*=\"asx-overview-essentials__label\"]",
        "[class*=\"asx-overview-essentials__value\"], [class*=\"asx-overview-essentials__status\"]");

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
                            if (child.tagName === 'A' || child.tagName === 'BUTTON'
                                || child.getAttribute('role') === 'button') {
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
    internal static readonly TimeSpan PrimaryAppearTimeout = TimeSpan.FromSeconds(10);
    internal static readonly TimeSpan FallbackAppearTimeout = TimeSpan.FromSeconds(5);

    // Live-found (2026-08-15, Cosmos DB): the Essentials framework component supports a THIRD field
    // group beyond `fields`/`customizeResourceFields` — `moreFields` — rendered behind a collapsed
    // "See more" toggle that isn't expanded by default, so its fields (Cosmos DB's "Backup policy"
    // confirmed; likely used by other types too) never reach the DOM at all and were silently
    // missing from every capture to date, independent of any selector/layout issue above. Confirmed
    // by grepping a raw debug HTML dump for the literal button text rather than guessing from the
    // builder source alone (`moreFields` being non-empty doesn't by itself prove the field is
    // unreachable — the collapsed button is what proves it).
    //
    // Live-found AGAIN (2026-08-15, same day — a 157-type full-catalog run): a first cut matched
    // *any* `<button>` anywhere whose trimmed text was "more"-shaped, and — critically — fell back to
    // searching the *top-level page* (not just the sandbox frame) when the frame-scoped search found
    // nothing. That fallback was the bug: the top-level page is Azure Portal's own chrome, present on
    // every single blade regardless of resource type, and it has its own "more"-shaped controls
    // (breadcrumb/command-bar overflow, notifications, etc.) that have nothing to do with Essentials.
    // Clicking one silently disrupted page state for whatever it actually was — and because
    // `ExtractAsync`'s outer try/catch treats any resulting failure as "no fields found" rather than
    // surfacing it, this wasn't a loud crash, it was a silent regression to zero extracted fields.
    // 33 of 157 types in that run lost previously-good, committed `portal-fields.json` data this way
    // (`OutputWriter` deletes the file when a "successful" capture returns zero fields, since it
    // can't distinguish a genuine now-empty panel from this) — caught only by noticing the test count
    // drop in `dotnet test` (`PortalFieldsConsistencyTests` is data-driven off however many
    // `portal-fields.json` files exist) before committing, not by the capture run itself reporting
    // anything wrong. Fixed by (1) dropping the top-level-page fallback entirely — there is no
    // legitimate reason to look for an Essentials-specific toggle outside the sandbox frame that
    // renders Essentials — and (2) requiring the `essentialsNoWrap-` class substring (the real
    // button's own class, confirmed via the same HTML dump used to find it in the first place) in
    // addition to the text match, so even a genuinely unrelated same-shaped button *inside* the
    // sandbox frame (e.g. a Recommendations widget rendered in the same iframe) can't be clicked by
    // mistake. `essentialsNoWrap-NNN` carries the same unstable per-build numeric suffix as
    // `essentialsItem-NNN` elsewhere in this file, hence substring matching, not an exact class.
    private const string MoreFieldsButtonJs = """
        () => {
            const btn = Array.from(document.querySelectorAll('button[class*="essentialsNoWrap-"]')).find(b =>
                /^(see |show )?\d*\s*more$/i.test((b.innerText || b.textContent || '').trim()));
            if (btn) { btn.click(); return true; }
            return false;
        }
        """;

    // Live-found (2026-08-15, same day as the fix above — the actual explanation for a much bigger
    // regression than the top-level-click bug alone): `EvaluateAsync` on a `FrameLocator`-scoped body
    // has to resolve the frame first, and that resolution uses Playwright's *default* timeout (30s)
    // when no explicit one is given — completely independent of this file's own PrimaryAppearTimeout/
    // FallbackAppearTimeout constants (confirmed live: quadrupling PrimaryAppearTimeout from 10s to
    // 40s changed nothing about the ~30s delay observed before a broken capture). Worse, the timeout
    // it throws is `TimeoutException`, a *different* type from `PlaywrightException` — every other
    // frame-existence check in this codebase (see DumpFiberBuilderSourceAsync/ChaseHelpersAsync) knows
    // to catch both together; this one, when first written, only caught `PlaywrightException`. On a
    // resource type whose sandbox frame isn't immediately present (for whatever reason — could be
    // genuine slow loading), the uncaught `TimeoutException` propagated out of this method, was caught
    // by `ExtractAsync`'s outer catch-all, and skipped *every* real extraction attempt below it
    // entirely — silently, with no error logged, just an empty field list after ~30s. This is very
    // likely the true explanation for a ~30-type capture regression that survived the top-level-click
    // fix unchanged: that fix addressed a real but different bug in the same feature; this one was the
    // one actually zeroing out unrelated types' field extraction. Fixed two ways: an explicit short
    // timeout so a missing frame fails fast instead of eating 30s doing nothing useful, and catching
    // `TimeoutException` alongside `PlaywrightException` so even a timeout here can never again skip
    // the extraction attempts that follow.
    private static async Task TryExpandMoreFieldsAsync(IFrameLocator sandboxFrame)
    {
        bool expanded;
        try
        {
            expanded = await sandboxFrame.Locator("body")
                .EvaluateAsync<bool>(MoreFieldsButtonJs, null, new LocatorEvaluateOptions { Timeout = 3000 });
        }
        catch (Exception ex) when (ex is TimeoutException or PlaywrightException)
        {
            expanded = false;
        }

        if (expanded)
        {
            // The click triggers a React state update, not a navigation — no loading indicator or
            // network activity to wait on, just a brief re-render. A fixed short delay is simpler
            // and just as reliable as a more elaborate wait here (unlike page-load timing elsewhere
            // in this file, there's no evidence this specific re-render is ever slow).
            await Task.Delay(500);
        }
    }

    public static async Task<IReadOnlyList<PortalField>> ExtractAsync(IPage page, ILogger logger, double captureTimeoutMultiplier = 1.0)
    {
        try
        {
            // Scaled by captureTimeoutMultiplier (config's captureTimeoutMultiplier, see
            // ResourceTypeDefinition) for types with a known-slow Overview blade — see PortalCaptureService
            // .CaptureAsync's own comment for the live evidence behind this. Applied to every fallback
            // combo's own budget below, not just the first, since a slow type isn't slow at only one
            // specific selector combo.
            var primaryAppearTimeout = PrimaryAppearTimeout * captureTimeoutMultiplier;
            var fallbackAppearTimeout = FallbackAppearTimeout * captureTimeoutMultiplier;

            var sandboxFrame = page.FrameLocator(OverviewSandboxIframeSelector);
            await TryExpandMoreFieldsAsync(sandboxFrame);

            var fields = await TryExtractFromLocatorAsync(
                sandboxFrame.Locator(CurrentItemSelector), CurrentExtractItemsJs, primaryAppearTimeout);
            if (fields.Count > 0)
            {
                return Finalize(fields);
            }

            fields = await TryExtractFromLocatorAsync(
                sandboxFrame.Locator(PropertyFieldLabelSelector), PropertyFieldExtractItemsJs, primaryAppearTimeout);
            if (fields.Count > 0)
            {
                return Finalize(fields);
            }

            fields = await TryExtractFromLocatorAsync(
                sandboxFrame.Locator(PropertiesFormLabelSelector), PropertiesFormExtractItemsJs, primaryAppearTimeout);
            if (fields.Count > 0)
            {
                return Finalize(fields);
            }

            fields = await TryExtractFromLocatorAsync(
                sandboxFrame.Locator(AsxItemSelector), AsxExtractItemsJs, primaryAppearTimeout);
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
            fields = await TryExtractFromLocatorAsync(page.Locator(CurrentItemSelector), CurrentExtractItemsJs, fallbackAppearTimeout);
            if (fields.Count > 0)
            {
                return Finalize(fields);
            }

            fields = await TryExtractFromLocatorAsync(sandboxFrame.Locator(LegacyItemSelector), LegacyExtractItemsJs, fallbackAppearTimeout);
            if (fields.Count > 0)
            {
                return Finalize(fields);
            }

            fields = await TryExtractFromLocatorAsync(page.Locator(LegacyItemSelector), LegacyExtractItemsJs, fallbackAppearTimeout);
            return Finalize(fields);
        }
        catch (Exception ex)
        {
            // Best-effort: a missing/changed Essentials panel shouldn't fail the whole capture —
            // the screenshot and raw ARM JSON remain the authoritative artifacts either way. But
            // silently swallowing here once already caused a real incident (see AGENT.md, the
            // TimeoutException-swallowing bug: a genuine bug elsewhere in this try block hid behind
            // an indistinguishable "0 Essentials field(s)" log line for ~30 types, caught only by
            // noticing the test count drop before committing) — log a warning so a *future* case of
            // "extraction threw" is distinguishable from "the panel genuinely had nothing to show".
            logger.LogWarning(ex, "Essentials extraction failed; capturing with 0 fields.");
            return [];
        }
    }

    private static async Task<List<PortalField>> TryExtractFromLocatorAsync(ILocator items, string extractJs, TimeSpan timeout)
    {
        try
        {
            // Attached, not Playwright's default Visible — this codebase already hit and fixed this
            // exact class of bug once (see FiberAnchorSelector's own wait, and DumpFiberBuilderSourceAsync's
            // comment on why), but this call site was never updated to match. Live-caught again
            // (2026-08-16, Microsoft.RecoveryServices/vaults): a genuinely legacy-layout blade whose
            // `.fxc-essentials-item` elements were confirmed present (via a raw HTML dump) with none of
            // the `fxs-display-none`/hidden markers seen elsewhere in this file, yet every extraction
            // attempt still returned 0 fields even after the timeout multiplier gave it 3x the normal
            // budget — a *visibility*-state wait, not a presence-state one, doesn't reliably resolve for
            // every blade's own render/animation timing. Safe to relax: the extraction JS below reads
            // `innerText` (already chosen specifically because it respects visibility, unlike
            // `textContent`), so a genuinely-still-hidden element just yields empty text and gets
            // filtered out downstream exactly like a real timeout would — this can only ever recover
            // fields that were falsely being missed, never fabricate data that wasn't really rendered.
            await items.First.WaitForAsync(new LocatorWaitForOptions
            {
                State = WaitForSelectorState.Attached,
                Timeout = (float)timeout.TotalMilliseconds,
            });
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

    // Public for the same reason ExtractCandidateHelperNames is: pure list-in/list-out logic with no
    // Playwright dependency, worth testing directly rather than only indirectly through a live
    // capture (see EssentialsExtractorTests).
    public static List<PortalField> Finalize(List<PortalField> fields) =>
        fields
            .Where(f => !ChromeLabels.Contains(f.Label))
            .Where(f => !ChromeValues.Contains(f.Value))
            // The portal can render an item twice during certain transitions (e.g. move-target
            // pickers); de-dupe by label, keeping the first occurrence.
            .DistinctBy(f => f.Label, StringComparer.OrdinalIgnoreCase)
            .ToList();

    // Live-found (2026-08-14, React fiber investigation): the grid/PropertyField layouts' Essentials
    // panel is always built by a shared framework component with a stable, non-minified
    // `displayName` of "Essentials" — true regardless of resource type — one fiber level below which
    // sits a per-extension-authored function taking the resource's raw ARM object as a prop and
    // returning the resolved `{label, value}` field array. That function's minified-but-not-obfuscated
    // source (`fiber.type.toString()`) still shows real `properties.*`/`sku.*`/`kind` member-access
    // expressions feeding each field — genuine raw ARM paths, not guesses — even when a friendly-text
    // transform wraps the value so it can never be found by value-matching against the raw JSON (e.g.
    // Storage Accounts' "Replication" is `sku.name` run through an untraced redundancy-name lookup;
    // FieldRecipeResolver's value-matcher structurally can't find that, no matter how it's tuned).
    // Labels themselves are resource-string references in source, never literal text (same
    // localization behavior as the Norwegian-timestamp finding below), so this dump can't replace the
    // DOM-captured label — it's read alongside the already-known label/value pairs, by a human (or an
    // LLM) turning a raw path into a verified FieldRecipe, the same manual-but-live-verified way every
    // other shortcut in FieldRecipeResolver.cs was built. Only fires for the grid/PropertyField
    // layouts (the ones with a per-type extension at all); the generic PropertiesForm fallback and
    // legacy layouts don't have this component to find. No-op unless ARDL_DEBUG_ESSENTIALS_DIR is set
    // — see PortalCaptureService and AGENT.md.
    internal const string FiberAnchorSelector =
        "[class*=\"essentialsItem-\"], [id^=\"PropertyField\"][id$=\"-label\"], label.ms-Label[aria-label][id]";

    // Shared with FieldBindingInvestigator (see that file's class comment for the full second-hop
    // module-chasing technique this anchors) — kept as one JS fragment, not two copies, so a future
    // portal DOM change only needs fixing in one place. Not a standalone function: pasted into the
    // body of a `() => { ... }` (or `(helperNames) => { ... }`) by each caller, leaving three
    // locals in scope afterward — `builderFn` (the field-builder function, or null),
    // `builderAnchorReason` (set only when builderFn is null, explaining why), and `builderFields`
    // (the Essentials component's already-resolved {label, value} array, best-effort).
    //
    // Live-found (2026-08-14, React fiber investigation): the grid/PropertyField layouts' Essentials
    // panel is always built by a shared framework component with a stable, non-minified
    // `displayName` of "Essentials" — true regardless of resource type — one fiber level below which
    // sits a per-extension-authored function taking the resource's raw ARM object as a prop and
    // returning the resolved `{label, value}` field array. That function's minified-but-not-obfuscated
    // source (`fiber.type.toString()`) still shows real `properties.*`/`sku.*`/`kind` member-access
    // expressions feeding each field — genuine raw ARM paths, not guesses — even when a friendly-text
    // transform wraps the value so it can never be found by value-matching against the raw JSON (e.g.
    // Storage Accounts' "Replication" is `sku.name` run through an untraced redundancy-name lookup;
    // FieldRecipeResolver's value-matcher structurally can't find that, no matter how it's tuned).
    // Labels themselves are resource-string references in source, never literal text (same
    // localization behavior as the Norwegian-timestamp finding below), so this dump can't replace the
    // DOM-captured label — it's read alongside the already-known label/value pairs, by a human (or an
    // LLM) turning a raw path into a verified FieldRecipe, the same manual-but-live-verified way every
    // other shortcut in FieldRecipeResolver.cs was built. Only fires for the grid/PropertyField
    // layouts (the ones with a per-type extension at all); the generic PropertiesForm fallback and
    // legacy layouts don't have this component to find.
    //
    // Live-found again (2026-08-15): picking `document.querySelector(...)`'s first DOM-order match
    // as the anchor is unreliable on types with a second, unrelated region using the *same* CSS
    // shapes — caught live on Compute/disks, whose secondary "Properties" side-tab (Size/IOPS/
    // Throughput config, a completely different feature) matched the PropertyField-label selector
    // just as validly as the real Essentials panel, and won because it happened to render first.
    // Fixed by preferring whichever candidate's own text contains "Resource group" — one of the four
    // composite fields the shared Essentials framework unconditionally injects via
    // `customizeResourceFields` (confirmed by reading every field-builder source this project has
    // dumped: `ResourceField.ResourceGroup` is never type-specific, never conditional) — falling back
    // to "Location" (the other near-universal one; a few global-scope types omit Resource Group
    // entirely) and only then to the first raw match, so this still degrades gracefully instead of
    // failing outright on a type where neither text is found.
    internal const string FindBuilderFunctionJsFragment = """
        let builderFn = null, builderAnchorReason = null, builderFields = null;
        const candidates = Array.from(document.querySelectorAll(
            '[class*="essentialsItem-"], [id^="PropertyField"][id$="-label"], label.ms-Label[aria-label][id]'));
        const textOfCandidate = el => el.innerText || el.textContent || '';
        const anchor = candidates.find(el => textOfCandidate(el).includes('Resource group'))
            || candidates.find(el => textOfCandidate(el).includes('Location'))
            || candidates[0]
            || null;
        if (!anchor) {
            builderAnchorReason = 'no anchor element found in this frame';
        } else {
            const fiberKey = Object.keys(anchor).find(k => k.startsWith('__reactFiber'));
            if (!fiberKey) {
                builderAnchorReason = 'anchor element has no React fiber';
            } else {
                let fiber = anchor[fiberKey];
                let depth = 0;
                while (fiber && depth < 80) {
                    const displayName = typeof fiber.type === 'function'
                        ? (fiber.type.displayName || fiber.type.name)
                        : fiber.type;
                    if (displayName === 'Essentials') {
                        const builderFiber = fiber.return;
                        // React.memo/forwardRef wrap the real function inside an object
                        // ({ $$typeof, type/render: fn }) instead of exposing it as fiber.type
                        // directly — unwrap one level before giving up. Live-observed on Redis
                        // Enterprise (builderSource came back null despite fiber.return existing).
                        let fn = builderFiber?.type;
                        if (fn && typeof fn !== 'function') {
                            fn = fn.type ?? fn.render ?? null;
                        }
                        builderFn = typeof fn === 'function' ? fn : null;
                        try {
                            builderFields = (fiber.memoizedProps?.fields || []).map(f =>
                                (f && typeof f === 'object')
                                    ? { label: String(f.label ?? ''), value: typeof f.value === 'string' ? f.value : typeof f.value }
                                    : String(f));
                        } catch { /* best-effort */ }
                        break;
                    }
                    fiber = fiber.return;
                    depth++;
                }
                if (!builderFn && !builderAnchorReason) {
                    builderAnchorReason = 'no Essentials-displayName fiber within 80 levels of the anchor';
                }
            }
        }
        """;

    // Heuristic, not exhaustive: every real friendly-text-transform helper call this project has
    // ever found by hand (Storage's Ve/Le/je, Compute/disks' Hs/st, MongoDB's _t, AKS's `w`/`k` via
    // `he.W8`, Logic's Be/Pe/Qe/Fe, ...) is called *bare* — `Ve(...)`, not `something.Ve(...)` —
    // because it's a local function/const in the same module, not an imported hook or utility.
    // React hooks and imported utilities in this same minified code are consistently called with a
    // dot prefix instead (`l.useCallback(...)`, `(0,o.isFeatureEnabled)(...)`), even though the
    // identifier right before the dot is *also* short and minified — so "not immediately preceded
    // by `.`" turned out to be a far more reliable discriminator than the first cut's "immediately
    // follows `value:`" (which missed real calls sitting behind a ternary, e.g. Compute/disks'
    // `value:e.disk?.sku?.name?Hs(e.disk.sku.name):...` — live-caught by
    // EssentialsExtractorTests.ExtractCandidateHelperNames_FindsRealHelperCallsFromDiskBuilder).
    // Residual false positives: a handful of bare JS globals (String(...), Number(...), ...) are
    // explicitly excluded below; a locally-scoped callback invoked inline would still slip through
    // uncaught. This is a starting point for a human or LLM to chase via FieldBindingInvestigator,
    // not a guarantee — and a helper that's never called bare (only assigned to a variable first)
    // would be missed entirely.
    private static readonly Regex BareCallPattern = new(
        @"(?<![.\w$])([A-Za-z_$][A-Za-z0-9_$]{0,6})\(", RegexOptions.Compiled);

    private static readonly HashSet<string> KnownNonHelperBareCalls = new(StringComparer.Ordinal)
    {
        "String", "Number", "Boolean", "Array", "Object", "Date", "RegExp", "Map", "Set", "Promise",
        "Symbol", "Error", "JSON", "Math", "parseInt", "parseFloat", "isNaN", "isFinite",
        "encodeURIComponent", "decodeURIComponent", "if", "for", "while", "switch", "catch", "function",
        "return",
    };

    public static IReadOnlyList<string> ExtractCandidateHelperNames(string builderSource) =>
        BareCallPattern.Matches(builderSource)
            .Select(m => m.Groups[1].Value)
            .Where(name => !KnownNonHelperBareCalls.Contains(name))
            .Distinct(StringComparer.Ordinal)
            .OrderBy(n => n, StringComparer.Ordinal)
            .ToList();

    public static async Task DumpFiberBuilderSourceAsync(IPage page, string outputPath)
    {
        const string js = "() => {\n" + FindBuilderFunctionJsFragment + """
                const builderSource = builderFn ? builderFn.toString() : null;
                if (!builderFn) {
                    return JSON.stringify({ found: false, reason: builderAnchorReason });
                }
                return JSON.stringify({ found: true, resolvedFields: builderFields, builderSource }, null, 1);
            }
            """;

        // The real extractor waits (up to PrimaryAppearTimeout) for one of these same selectors
        // before reading anything — this dump has to wait too, or it misses every slow-rendering
        // blade type. First cut used PrimaryAppearTimeout/FallbackAppearTimeout directly (10s/5s)
        // and still missed all 3 of the slowest types in the 2026-08-14 pilot batch (VMs, Postgres
        // flexible servers, Synapse workspaces — all independently confirmed slow: each logged a
        // "loading indicators still visible after 15s" warning from StableRenderWaiter). Given
        // twice the budget here since, unlike the production extractor, this only ever runs one
        // combo (no grid/PropertyField/PropertiesForm/legacy fallback chain to also fit inside
        // HardCaptureTimeout) and is opt-in debug tooling, not on the hot path.
        var dumpPrimaryTimeout = PrimaryAppearTimeout * 2;
        var dumpFallbackTimeout = FallbackAppearTimeout * 2;

        // Live-found (2026-08-15): waiting for `.First` to become *visible* (Playwright's default
        // wait state) is unreliable on a type with a second, DOM-attached-but-hidden region using
        // the same selectors — Compute/disks' secondary "Properties" side-tab content (same class
        // shapes as the real Essentials panel, see FindBuilderFunctionJsFragment's own comment)
        // isn't present in the DOM at page-load, but attaches a couple of seconds later; once it
        // does, `.First` can start resolving to that hidden duplicate instead of the real, already-
        // visible Essentials panel, and a *visible*-state wait for that specific match then times
        // out outright — reproduced twice in a row calling FieldBindingInvestigator.ChaseHelpersAsync
        // moments after this same dump had just succeeded. Waiting for merely *attached* instead
        // fixes it and is the actually-correct requirement here: this reads React fiber internals
        // off the DOM node, which works identically whether the element is visible or not — unlike
        // EssentialsExtractor.ExtractAsync's own waits (kept at the Playwright default), which
        // legitimately need rendered, visible text.
        string json;
        try
        {
            var sandboxFrame = page.FrameLocator(OverviewSandboxIframeSelector);
            try
            {
                await sandboxFrame.Locator(FiberAnchorSelector).First.WaitForAsync(new LocatorWaitForOptions
                {
                    State = WaitForSelectorState.Attached,
                    Timeout = (float)dumpPrimaryTimeout.TotalMilliseconds,
                });
                json = await sandboxFrame.Locator("body").EvaluateAsync<string>(js);
            }
            catch (Exception frameEx) when (frameEx is TimeoutException or PlaywrightException)
            {
                await page.Locator(FiberAnchorSelector).First.WaitForAsync(new LocatorWaitForOptions
                {
                    State = WaitForSelectorState.Attached,
                    Timeout = (float)dumpFallbackTimeout.TotalMilliseconds,
                });
                json = await page.EvaluateAsync<string>(js);
            }
        }
        catch (Exception ex)
        {
            json = $$"""{ "found": false, "reason": "extraction threw: {{ex.Message.Replace("\"", "'")}}" }""";
        }

        // Candidate helper names are added here, in C#, after the JS round-trip — cheap (pure regex
        // over a string already in hand) and keeps ExtractCandidateHelperNames unit-testable without
        // a browser. Only when a builder was actually found; a `found: false` dump has no source to
        // scan.
        try
        {
            using var doc = System.Text.Json.JsonDocument.Parse(json);
            if (doc.RootElement.TryGetProperty("found", out var foundEl) && foundEl.GetBoolean()
                && doc.RootElement.TryGetProperty("builderSource", out var srcEl)
                && srcEl.ValueKind == System.Text.Json.JsonValueKind.String)
            {
                var candidates = ExtractCandidateHelperNames(srcEl.GetString()!);
                var withCandidates = new Dictionary<string, object?>
                {
                    ["found"] = true,
                    ["resolvedFields"] = doc.RootElement.TryGetProperty("resolvedFields", out var f) ? f : (object?)null,
                    ["builderSource"] = srcEl.GetString(),
                    ["candidateHelperNames"] = candidates,
                };
                json = System.Text.Json.JsonSerializer.Serialize(
                    withCandidates, new System.Text.Json.JsonSerializerOptions { WriteIndented = true });
            }
        }
        catch (System.Text.Json.JsonException)
        {
            // json wasn't valid JSON at all (shouldn't happen — every branch above produces valid
            // JSON.stringify output or a hand-written fallback) — write it through unmodified rather
            // than lose the diagnostic.
        }

        Directory.CreateDirectory(Path.GetDirectoryName(outputPath)!);
        await File.WriteAllTextAsync(outputPath, json);
    }

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
