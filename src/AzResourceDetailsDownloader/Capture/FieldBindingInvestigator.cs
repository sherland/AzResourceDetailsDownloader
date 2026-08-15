using System.Text.Json;
using Microsoft.Playwright;

namespace AzResourceDetailsDownloader.Capture;

// Automates the "second hop" of the live field-binding investigation technique developed
// 2026-08-14/15 (see AGENT.md's "The full friendly-name lookup tables were sitting in already-
// loaded portal JS the whole time" section for the full narrative and every example this was
// validated against). EssentialsExtractor.DumpFiberBuilderSourceAsync already does the *first*
// hop — DOM element -> React fiber -> the Essentials panel's field-builder function -> that
// function's own minified-but-readable source, which shows real `properties.*`/`sku.*` paths but
// usually calls further helper functions (`Ve`, `Hs`, `he.W8`, ...) to turn a raw enum into the
// friendly text the portal actually displays. This class chases those helper functions into
// whichever *other* already-loaded script file defines them, then chases the resource-string
// table they reference for the literal display text — the two extra searches that, done by hand
// via ad-hoc `playwright-cli eval` commands throughout this project's investigation sessions,
// found every `FieldRecipeResolver` shortcut added since. Productionized here (opt-in, gated by
// ARDL_CHASE_HELPER_NAMES — see PortalCaptureService) specifically so a future session — human or
// AI — can run one command instead of hand-typing a fresh JS blob and rediscovering the same
// cmd.exe-quoting and short-name-collision gotchas from scratch.
//
// Everything below reads ONLY code the browser has already downloaded to render the page (no new
// API calls, no extra Azure resources beyond the one instance already open for the surrounding
// capture) — same "live-verified, never guessed" standard as config/azure-locations.json, applied
// to portal JS instead of a fetched docs page.
//
// Robustness notes (why the algorithm looks the way it does, not simpler):
//  - IFRAME-AWARE: reuses EssentialsExtractor.OverviewSandboxIframeSelector/FindBuilderFunctionJsFragment
//    verbatim (not a re-implementation) so this and the production extractor can never quietly
//    diverge on which frame or which anchor is correct. A resource type whose Overview blade has
//    no sandbox iframe at all (falls through to the top-level page) is handled the same way
//    DumpFiberBuilderSourceAsync already handles it.
//  - MANY-FIELDS-SAFE: doesn't care how many Essentials fields a type has — it only needs the one
//    already-robust anchor (see FindBuilderFunctionJsFragment's own comment on why "Resource
//    group" text, not a blind first-DOM-match, is used) to reach the single field-builder function
//    that returns *all* of them at once.
//  - SHORT-NAME-COLLISION-SAFE: a helper name like `Fe`/`Be` can coincidentally be declared by an
//    unrelated vendored library bundled into the same multi-megabyte chunk (live-caught: Logic
//    Apps' field-builder chunk also contains a lodash-derived `Fe`/`Be`/`Pe`/`Qe`, ~500KB away from
//    the real declarations). Every declaration match in the host file is ranked by *distance from
//    the builder function's own position in that file* — the real declaration is reliably close
//    (same webpack module), a coincidental one in a vendored chunk is not.
//  - CROSS-CHUNK-SAFE: a helper isn't always declared in the same file as its call site — AKS's
//    `he.W8`/`he.MF` are imported from a separate webpack module than the field-builder itself
//    (`he=rr(5379)`, a different chunk file entirely). When nothing matches in the host file, every
//    *other* loaded script is searched too, and the result is flagged `crossChunk: true` so a
//    reader knows the distance-ranking heuristic above didn't apply (there was only one candidate).
//
// Known limitations, honestly, not smoothed over:
//  - The resource-string-table search is itself a heuristic (extracts `Namespace.Key`-shaped
//    identifiers from the helper's own snippet, then searches every loaded script for
//    `Namespace:{`) and can miss a table that isn't already loaded yet (Azure Portal lazy-loads
//    some blade-specific string bundles only once a specific sub-panel is opened) or find the
//    wrong same-named object if two unrelated modules happen to share a namespace name. Treat its
//    output as a strong lead, not a verified answer — the same "verify by hand before trusting"
//    standard every FieldRecipeResolver shortcut in this project was already held to.
//  - Fetches every loaded `.js` resource up to once each (cached across all helper names in one
//    call) — on a type with many chunks this can be 100-250 files, some hundreds of KB each, so a
//    single investigation can take tens of seconds. There's no hard timeout here by design: this
//    is manual debug tooling run one type at a time, not part of the automated batch pipeline, so
//    a slow-but-complete answer beats a fast-but-truncated one.
//  - If Azure Portal ever changes its build tooling (a different minifier, actual code obfuscation
//    instead of just short names, or genuinely removing `Function.prototype.toString`'s source
//    fidelity) this whole technique stops working — there's no fallback. If that happens, start by
//    re-verifying FindBuilderFunctionJsFragment's core assumption (an unminified "Essentials"
//    fiber displayName) still holds via a one-off `playwright-cli` session before assuming this
//    class is still correct.
public static class FieldBindingInvestigator
{
    // Built per call, not a fixed const — Playwright's EvaluateAsync `arg` parameter turned out
    // unreliable for this (live-found 2026-08-15, in order: an `IReadOnlyList<string>` didn't
    // arrive as something `for...of`-iterable — `TypeError: helperNames is not iterable`; switching
    // to a plain joined string didn't arrive as a string either — `TypeError:
    // helperNamesCsv.split is not a function`. Both were misread at first as a DOM-timing problem,
    // since the real exception was being caught by the sandbox/fallback retry logic below and
    // replaced with a misleading "fallback timed out" message — see that try/catch's own comment).
    // Sidesteps the whole `arg`-passing mechanism instead: the helper names are JSON-serialized and
    // embedded directly as a literal in the JS source, and the function takes zero parameters.
    // Composed from EssentialsExtractor's shared anchor/fiber-walk fragment (see that class for why
    // it's shared, not duplicated) plus the two-hop file chase.
    private static string BuildChaseJs(IReadOnlyList<string> helperNames)
    {
        var helperNamesJsonLiteral = JsonSerializer.Serialize(helperNames);
        return "async () => {\n" +
            $"const helperNames = {helperNamesJsonLiteral};\n" + EssentialsExtractor.FindBuilderFunctionJsFragment + """
            if (!builderFn) {
                return JSON.stringify({ found: false, reason: builderAnchorReason });
            }
            const builderSource = builderFn.toString();
            const needle = builderSource.slice(-100);

            const scriptUrls = Array.from(new Set(
                performance.getEntriesByType('resource').map(r => r.name).filter(u => u.endsWith('.js'))));
            const fileCache = new Map();
            async function getFile(url) {
                if (fileCache.has(url)) return fileCache.get(url);
                let text = null;
                try {
                    const resp = await fetch(url);
                    text = resp.ok ? await resp.text() : null;
                } catch (e) {
                    text = null;
                }
                fileCache.set(url, text);
                return text;
            }

            let hostFile = null, hostText = null;
            for (const url of scriptUrls) {
                const text = await getFile(url);
                if (text && text.includes(needle)) { hostFile = url; hostText = text; break; }
            }
            if (!hostText) {
                return JSON.stringify({
                    found: true, builderSource, checkedScriptCount: scriptUrls.length,
                    error: 'host file not found — the builder source snippet used as a needle did not ' +
                        'match any loaded .js resource. Read builderSource by hand instead.',
                }, null, 1);
            }
            const anchorPos = hostText.indexOf(needle);

            // Resolves a dotted name (e.g. "he.W8", AKS's `he.W8`/`he.MF` shape — a helper imported
            // from another webpack module and called through the module's own namespace object,
            // never as a bare identifier) to the real *local* name inside whichever module actually
            // defines it, AND to that module's own start position — needed because the resolved
            // local name is very often a single letter (`g`, `k`, ...), which collides constantly
            // across an 800KB+ bundle; ranking its declaration search by distance from the *module's*
            // own start (not the far-away field-builder position used for every other, bare-called
            // helper) is what actually disambiguates it. Two live-confirmed shapes, both stable
            // webpack conventions, 2026-08-15:
            //   - the binding itself: `he=rr(5379)` (`NAMESPACE=REQUIRE_FN(MODULE_ID)`)
            //   - that module's own export map: `5379:function(e,t,r){...r.d(t,{W8:function(){
            //     return g}...})}` — search scoped to start at "5379:function(" specifically, not
            //     the whole file, so an unrelated module's coincidentally-similar export key can't
            //     be picked up by mistake.
            // Falls back to a plain bare-name search (no module scoping) if either step doesn't
            // resolve — better an honest best-effort than silently giving up on a dotted input.
            async function resolveAlias(name) {
                if (!name.includes('.')) {
                    return { resolvedName: name, moduleAnchorPos: null, aliasResolvedFrom: null };
                }
                const [namespaceName, lastSegment] = [name.split('.')[0], name.split('.').pop()];
                const escapedNs = namespaceName.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
                const bindingPattern = new RegExp(
                    '(?<![A-Za-z0-9_$])' + escapedNs + '=[A-Za-z_$][A-Za-z0-9_$]*\\((\\d+)\\)');
                const bindingMatch = bindingPattern.exec(hostText);
                const escapedSeg = lastSegment.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
                const exportPattern = new RegExp(
                    '(?<![A-Za-z0-9_$])' + escapedSeg + '\\s*:\\s*function\\s*\\(\\s*\\)\\s*\\{\\s*return\\s+([A-Za-z_$][A-Za-z0-9_$]*)', 'g');

                if (bindingMatch) {
                    const moduleId = bindingMatch[1];
                    const moduleStartIdx = hostText.indexOf(moduleId + ':function(');
                    if (moduleStartIdx >= 0) {
                        exportPattern.lastIndex = moduleStartIdx;
                        const em = exportPattern.exec(hostText);
                        // Sanity bound: the export map is expected within a few KB of the module's
                        // own start, not merely "somewhere later in the file" (exec with lastIndex
                        // set doesn't stop at the module's own end, since these are minified single-
                        // line files with no reliable brace-matching shortcut here).
                        if (em && em.index - moduleStartIdx < 8000) {
                            return {
                                resolvedName: em[1], moduleAnchorPos: moduleStartIdx,
                                aliasResolvedFrom: `${name} -> module ${moduleId} @${moduleStartIdx} -> ${em[1]}`,
                            };
                        }
                    }
                }
                // Fallback: no scoped module boundary found — search every loaded file for the bare
                // export-map shape, unscoped (the same risk of picking an unrelated same-named
                // export this whole function exists to avoid, but still better than nothing).
                for (const url of [hostFile, ...scriptUrls.filter(u => u !== hostFile)]) {
                    const text = await getFile(url);
                    if (!text) continue;
                    exportPattern.lastIndex = 0;
                    const am = exportPattern.exec(text);
                    if (am) {
                        return {
                            resolvedName: am[1], moduleAnchorPos: null,
                            aliasResolvedFrom: `${name} -> ${url}#${am.index} -> ${am[1]} (unscoped: no module-binding match)`,
                        };
                    }
                }
                return {
                    resolvedName: lastSegment, moduleAnchorPos: null,
                    aliasResolvedFrom: `${name} -> unresolved, using bare "${lastSegment}"`,
                };
            }

            const helperResults = {};
            for (const originalName of helperNames) {
                const { resolvedName: name, moduleAnchorPos, aliasResolvedFrom } = await resolveAlias(originalName);
                const rankingAnchorPos = moduleAnchorPos !== null ? moduleAnchorPos : anchorPos;
                const escaped = name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
                const declPattern = new RegExp(
                    '(?<![A-Za-z0-9_$])(?:function\\s+' + escaped + '\\s*\\(|' + escaped + '=(?!=))', 'g');

                const hostMatches = [];
                let m;
                while ((m = declPattern.exec(hostText))) {
                    hostMatches.push(m.index);
                }
                // Module-scoped ranking (an alias-resolved name, e.g. AKS's `he.W8` -> `g`) must
                // rank strictly forward from the module's own start ahead of anything before it —
                // plain absolute distance picks the wrong one whenever an unrelated, closer-in-raw-
                // distance same-name declaration sits just *before* the module boundary (live-caught
                // 2026-08-15: an enum-init idiom, `(g||(g={}))`, sitting 424 chars before module
                // 5379's own start outscored the real `g=e=>{...}` declaration 631 chars *after* it
                // — nothing about that enum-init pattern is inside module 5379's own scope at all).
                // A bare (non-aliased) helper keeps the original nearest-either-direction ranking,
                // already proven correct against Storage/Disks/MongoDB/Logic this session.
                if (moduleAnchorPos !== null) {
                    hostMatches.sort((a, b) => {
                        const aAfter = a >= rankingAnchorPos, bAfter = b >= rankingAnchorPos;
                        if (aAfter !== bAfter) return aAfter ? -1 : 1;
                        return Math.abs(a - rankingAnchorPos) - Math.abs(b - rankingAnchorPos);
                    });
                } else {
                    hostMatches.sort((a, b) => Math.abs(a - rankingAnchorPos) - Math.abs(b - rankingAnchorPos));
                }

                let chosenFile = hostFile, chosenPos = null, crossChunk = false, otherCandidateCount = 0;
                if (hostMatches.length > 0) {
                    chosenPos = hostMatches[0];
                    otherCandidateCount = hostMatches.length - 1;
                } else {
                    for (const url of scriptUrls) {
                        if (url === hostFile) continue;
                        const text = await getFile(url);
                        if (!text) continue;
                        declPattern.lastIndex = 0;
                        const mm = declPattern.exec(text);
                        if (mm) {
                            chosenFile = url;
                            chosenPos = mm.index;
                            crossChunk = true;
                            break;
                        }
                    }
                }

                if (chosenPos === null) {
                    helperResults[originalName] = { found: false, aliasResolvedFrom };
                    continue;
                }

                const fileText = crossChunk ? await getFile(chosenFile) : hostText;
                const snippet = fileText.slice(Math.max(0, chosenPos - 40), chosenPos + 1500);

                // Candidate resource-string namespace references inside the snippet (e.g.
                // "Te.Replication", "H.ManagedDisks.DiskType") — a second search below looks for
                // whichever loaded file defines that same dotted name's literal display text.
                const refPattern = /\b[A-Za-z_$][A-Za-z0-9_$]*\.[A-Za-z][A-Za-z0-9_$]*(?:\.[A-Za-z][A-Za-z0-9_$]*){0,3}\b/g;
                const refs = new Set();
                let rm;
                while ((rm = refPattern.exec(snippet))) {
                    const parts = rm[0].split('.');
                    if (parts.length >= 2 && /^[A-Z]/.test(parts[1])) {
                        refs.add(rm[0]);
                    }
                }
                const namespaces = Array.from(new Set(Array.from(refs).map(r => r.split('.')[1]))).slice(0, 8);

                const stringTables = {};
                for (const ns of namespaces) {
                    for (const url of scriptUrls) {
                        const text = await getFile(url);
                        if (!text) continue;
                        const idx = text.indexOf(ns + ':{');
                        if (idx >= 0) {
                            stringTables[ns] = { file: url, snippet: text.slice(idx, idx + 1000) };
                            break;
                        }
                    }
                }

                helperResults[originalName] = {
                    found: true,
                    resolvedName: name,
                    aliasResolvedFrom,
                    file: chosenFile,
                    crossChunk,
                    otherCandidateCount,
                    snippet,
                    candidateResourceStringRefs: Array.from(refs).slice(0, 25),
                    resourceStringTableSnippets: stringTables,
                };
            }

            return JSON.stringify({ found: true, hostFile, builderSourceTail: needle, helperResults }, null, 1);
        }
        """;
    }

    // Same appear-wait budget as DumpFiberBuilderSourceAsync (doubled from the production
    // extractor's own timeouts, same reasoning: this only runs at all when that dump would also
    // succeed, on the same anchor, so the same timing story applies) — deliberately NOT doubled
    // again here even though this does real network fetching of every loaded script on top of the
    // fiber walk: EvaluateAsync itself has no timeout, so the *wait-for-anchor* budget only needs
    // to cover reaching a stable, walkable DOM, not the fetch phase that follows.
    //
    // Live-found (2026-08-15), reproduced twice in a row on Compute/disks: waiting for `.First` to
    // become *visible* (Playwright's default) is unreliable when a second, DOM-attached-but-hidden
    // region shares the same selectors (that type's secondary "Properties" side-tab — see
    // EssentialsExtractor.FindBuilderFunctionJsFragment's own comment on why the JS itself already
    // disambiguates by text content instead of trusting DOM order). That hidden region isn't
    // present at page-load but attaches a couple of seconds later; once it does, `.First` can start
    // matching it instead of the real, already-visible panel, and this call — running moments after
    // DumpFiberBuilderSourceAsync had already succeeded against the very same page — would time out
    // outright waiting for THAT specific (hidden) match to become visible. Waiting for merely
    // *attached* fixes it and is the actually-correct requirement: reading React fiber internals off
    // a DOM node doesn't need the node to be visible.
    public static async Task<string> ChaseHelpersAsync(IPage page, IReadOnlyList<string> helperNames)
    {
        if (helperNames.Count == 0)
        {
            return """{ "found": false, "reason": "no helper names given" }""";
        }

        var js = BuildChaseJs(helperNames);
        var primaryTimeout = EssentialsExtractor.PrimaryAppearTimeout * 2;
        var fallbackTimeout = EssentialsExtractor.FallbackAppearTimeout * 2;

        try
        {
            var sandboxFrame = page.FrameLocator(EssentialsExtractor.OverviewSandboxIframeSelector);
            try
            {
                await sandboxFrame.Locator(EssentialsExtractor.FiberAnchorSelector).First.WaitForAsync(new LocatorWaitForOptions
                {
                    State = WaitForSelectorState.Attached,
                    Timeout = (float)primaryTimeout.TotalMilliseconds,
                });
                return await sandboxFrame.Locator("body").EvaluateAsync<string>(js);
            }
            catch (Exception frameEx) when (frameEx is TimeoutException or PlaywrightException)
            {
                // Kept permanently, not scaffolding: without surfacing frameEx here, a sandbox-side
                // failure that ISN'T actually a timing/DOM problem gets silently replaced by
                // whatever the fallback attempt's own (usually misleading) exception says instead.
                // Live-caught exactly this way (2026-08-15): two consecutive real bugs in how
                // EvaluateAsync's `arg` parameter was being used (see BuildChaseJs's own comment for
                // both) looked identical to a DOM-timing race for 5 capture runs in a row, because
                // the sandbox attempt's real exception was discarded here every time — the fallback
                // against the top-level page (which never has these elements at all) always times
                // out at exactly its own budget regardless of what actually failed in the sandbox
                // attempt, producing the same misleading symptom no matter the real cause.
                try
                {
                    await page.Locator(EssentialsExtractor.FiberAnchorSelector).First.WaitForAsync(new LocatorWaitForOptions
                    {
                        State = WaitForSelectorState.Attached,
                        Timeout = (float)fallbackTimeout.TotalMilliseconds,
                    });
                    return await page.EvaluateAsync<string>(js);
                }
                catch (Exception fallbackEx)
                {
                    var safe = (Exception e) => e.Message.Replace("\"", "'").Replace("\n", " ").Replace("\r", "");
                    return $$"""
                        { "found": false, "reason": "both sandbox and fallback failed",
                          "sandboxException": "{{frameEx.GetType().Name}}: {{safe(frameEx)}}",
                          "fallbackException": "{{fallbackEx.GetType().Name}}: {{safe(fallbackEx)}}" }
                        """;
                }
            }
        }
        catch (Exception ex)
        {
            return $$"""{ "found": false, "reason": "chase threw: {{ex.Message.Replace("\"", "'").Replace("\n", " ")}}" }""";
        }
    }
}
