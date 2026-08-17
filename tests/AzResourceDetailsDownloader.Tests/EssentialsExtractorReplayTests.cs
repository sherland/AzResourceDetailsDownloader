using AzResourceDetailsDownloader.Capture;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Playwright;

namespace AzResourceDetailsDownloader.Tests;

// Real-browser regression tests for EssentialsExtractor's DOM-scraping logic — the one part of this
// class no pure C# unit test can meaningfully cover, since it lives entirely in "does this selector
// match the real portal markup." Runs a real headless Chromium (see PlaywrightBrowserFixture)
// against small, hand-authored HTML fixtures below, then calls the actual production
// EssentialsExtractor.ExtractAsync — not a reimplementation or a mock.
//
// The fixtures are DELIBERATELY NOT verbatim live captures. A prior investigation into building
// these from real ARDL_DEBUG_ESSENTIALS_DIR dumps found ~150 scratch HTML files from an earlier
// session, and found the real subscription ID alone in 146 of 147 of them (tenant ID and the
// operator's email in several more) — a raw full-page portal dump has far more surface area for
// identity leakage than the structured JSON OutputNormalizer already redacts, and this project has
// already been burned by exactly this class of leak once (see AGENT.md). Rather than trying to
// scrub every occurrence out of a multi-hundred-KB single-line dump and hoping nothing was missed,
// these fixtures are hand-written from EssentialsExtractor.cs's own selectors/extraction-JS (which
// this file's author can read with zero PII risk, since it's just implementation code) with fake
// field values throughout. Same honesty precedent as config/portal-fields.inferred.json: a
// deliberate, labeled exception to "never guessed, always live-verified," not a silent one — if the
// real portal DOM structure changes, these fixtures need updating by hand the same way
// EssentialsExtractor.cs's own selectors would.
public sealed class EssentialsExtractorReplayTests(PlaywrightBrowserFixture fixture) : IClassFixture<PlaywrightBrowserFixture>
{
    // Every sandbox-frame layout (grid/PropertyField/PropertiesForm/Asx) is reached through this
    // exact iframe selector in production (EssentialsExtractor.OverviewSandboxIframeSelector) — a
    // real <iframe srcdoc="..."> is a real, same-origin-for-automation-purposes frame Playwright's
    // FrameLocator can locate and evaluate against, the same way it already handles the real
    // cross-origin sandbox iframe in production.
    //
    // captureTimeoutMultiplier: a fixture that only carries ONE layout's markup makes ExtractAsync's
    // real cascade genuinely wait out every EARLIER combo's full PrimaryAppearTimeout/
    // FallbackAppearTimeout before falling through — correct behavior, matching production, but a
    // first pass at these tests with the default multiplier (1.0) took 2m46s for 6 tests (the
    // Legacy/top-level cases fail through nearly the whole cascade first). 0.1 scales every wait in
    // that same real cascade down proportionally (1s/0.5s instead of 10s/5s per combo) rather than
    // skipping or mocking any of it — same logic, same order, just not spending tens of real seconds
    // waiting on a selector this test already knows won't appear.
    private const double TestCaptureTimeoutMultiplier = 0.1;

    private async Task<IReadOnlyList<PortalField>> ExtractFromSandboxFrameAsync(string innerHtml)
    {
        var page = await fixture.Browser.NewPageAsync();
        try
        {
            await page.SetContentAsync("""<!DOCTYPE html><html><body><iframe class="fxs-reactview-frame-active"></iframe></body></html>""");
            await page.EvalOnSelectorAsync(
                "iframe.fxs-reactview-frame-active", "(el, html) => { el.srcdoc = html; }", innerHtml);
            return await EssentialsExtractor.ExtractAsync(page, NullLogger.Instance, TestCaptureTimeoutMultiplier);
        }
        finally
        {
            await page.CloseAsync();
        }
    }

    // No sandbox iframe at all — the pre-2026-08-14 top-level path, still tried as the final
    // fallback (see ExtractAsync's own cascade comment) for a blade type that never migrated.
    private async Task<IReadOnlyList<PortalField>> ExtractFromTopLevelPageAsync(string html)
    {
        var page = await fixture.Browser.NewPageAsync();
        try
        {
            await page.SetContentAsync(html);
            return await EssentialsExtractor.ExtractAsync(page, NullLogger.Instance, TestCaptureTimeoutMultiplier);
        }
        finally
        {
            await page.CloseAsync();
        }
    }

    // Grid layout — the "new" (2026-08-14 redesign) shape: essentialsItem-NNN wraps an
    // essentialsLabel-NNN/essentialsValue-NNN pair, NNN an unstable per-render suffix (matched as a
    // substring, not an exact class — see EssentialsExtractor.CurrentItemSelector).
    [Fact]
    public async Task ExtractAsync_GridLayout_ExtractsFieldsFromSandboxIframe()
    {
        const string html = """
            <!DOCTYPE html><html><body>
              <div class="essentialsItem-abc123">
                <div class="essentialsLabel-1">Resource group</div>
                <div class="essentialsValue-1">rg-example</div>
              </div>
              <div class="essentialsItem-abc124">
                <div class="essentialsLabel-2">Location</div>
                <div class="essentialsValue-2">Norway East</div>
              </div>
            </body></html>
            """;

        var fields = await ExtractFromSandboxFrameAsync(html);

        Assert.Equal(
            [new PortalField("Resource group", "rg-example"), new PortalField("Location", "Norway East")],
            fields);
    }

    // PropertyField/Accordion layout — Fluent UI AccordionPanel, most Microsoft.Network/* types.
    // Label and value are NOT siblings under a shared item container (unlike Grid) — linked via
    // aria-labelledby (see EssentialsExtractor.PropertyFieldLabelSelector/ExtractItemsJs).
    [Fact]
    public async Task ExtractAsync_PropertyFieldLayout_ExtractsFieldsFromSandboxIframe()
    {
        const string html = """
            <!DOCTYPE html><html><body>
              <div id="PropertyField1-label">Resource group</div>
              <div aria-labelledby="PropertyField1-label">rg-example</div>
              <div id="PropertyField2-label">Location</div>
              <div aria-labelledby="PropertyField2-label">Norway East</div>
            </body></html>
            """;

        var fields = await ExtractFromSandboxFrameAsync(html);

        Assert.Equal(
            [new PortalField("Resource group", "rg-example"), new PortalField("Location", "Norway East")],
            fields);
    }

    // Generic "Properties" form fallback — types with no custom Overview blade extension at all
    // (Portal/dashboards, OperationalInsights/querypacks, ...). Office Fabric label.ms-Label[aria-
    // label] paired to a readonly <input> via aria-labelledby; value read from the input's `.value`,
    // not its text (see EssentialsExtractor.PropertiesFormLabelSelector/ExtractItemsJs).
    [Fact]
    public async Task ExtractAsync_PropertiesFormLayout_ExtractsFieldsFromSandboxIframe()
    {
        const string html = """
            <!DOCTYPE html><html><body>
              <label class="ms-Label" aria-label="Resource group" id="lbl1"></label>
              <input aria-labelledby="lbl1" value="rg-example" readonly />
              <label class="ms-Label" aria-label="Location" id="lbl2"></label>
              <input aria-labelledby="lbl2" value="Norway East" readonly />
            </body></html>
            """;

        var fields = await ExtractFromSandboxFrameAsync(html);

        Assert.Equal(
            [new PortalField("Resource group", "rg-example"), new PortalField("Location", "Norway East")],
            fields);
    }

    // Custom-built extension pane bypassing the shared framework component entirely (literal, not
    // per-render-suffixed, class names — see EssentialsExtractor.AsxItemSelector/ExtractItemsJs).
    // Modifier suffixes (--interactive, --success, ...) alongside the base class are why the value
    // selector matches by substring, not exact class.
    [Fact]
    public async Task ExtractAsync_AsxLayout_ExtractsFieldsFromSandboxIframe()
    {
        const string html = """
            <!DOCTYPE html><html><body>
              <div class="asx-overview-essentials__row">
                <div class="asx-overview-essentials__label">Resource group</div>
                <div class="asx-overview-essentials__value">rg-example</div>
              </div>
              <div class="asx-overview-essentials__row">
                <div class="asx-overview-essentials__label">Status</div>
                <div class="asx-overview-essentials__status--success">Succeeded</div>
              </div>
            </body></html>
            """;

        var fields = await ExtractFromSandboxFrameAsync(html);

        Assert.Equal(
            [new PortalField("Resource group", "rg-example"), new PortalField("Status", "Succeeded")],
            fields);
    }

    // Legacy pre-2026-08-14 top-level layout — no sandbox iframe present at all, still tried as the
    // last-resort fallback for any blade type that never migrated (see
    // EssentialsExtractor.LegacyItemSelector/ExtractItemsJs).
    [Fact]
    public async Task ExtractAsync_LegacyLayout_ExtractsFieldsFromTopLevelPage()
    {
        const string html = """
            <!DOCTYPE html><html><body>
              <div class="fxc-essentials-item">
                <div class="fxc-essentials-label">Resource group</div>
                <div class="fxc-essentials-value">rg-example</div>
              </div>
              <div class="fxc-essentials-item">
                <div class="fxc-essentials-label">Location</div>
                <div class="fxc-essentials-value">Norway East</div>
              </div>
            </body></html>
            """;

        var fields = await ExtractFromTopLevelPageAsync(html);

        Assert.Equal(
            [new PortalField("Resource group", "rg-example"), new PortalField("Location", "Norway East")],
            fields);
    }

    // Cross-check against the chrome-filtering/dedup logic (EssentialsExtractor.Finalize, already
    // unit-tested in isolation in EssentialsExtractorTests) actually being wired into the real
    // extraction path, not just correct on its own — a "Manage keys" chrome label should never
    // survive a real extraction, regardless of which layout it appears in.
    [Fact]
    public async Task ExtractAsync_FiltersChromeLabelsThroughTheRealExtractionPath()
    {
        const string html = """
            <!DOCTYPE html><html><body>
              <div class="fxc-essentials-item">
                <div class="fxc-essentials-label">Resource group</div>
                <div class="fxc-essentials-value">rg-example</div>
              </div>
              <div class="fxc-essentials-item">
                <div class="fxc-essentials-label">Manage keys</div>
                <div class="fxc-essentials-value">Click here to manage keys</div>
              </div>
            </body></html>
            """;

        var fields = await ExtractFromTopLevelPageAsync(html);

        Assert.Equal([new PortalField("Resource group", "rg-example")], fields);
    }
}
