---
name: research-pricing-hint
description: Research real, sourced Azure pricing for one ARM resource type in this repo's catalog (config/resource-types.json) and produce a ready-to-paste entry for config/pricing-hints.json. Use this whenever asked to add, fix, or re-verify pricing for a specific armType, whenever a catalog entry's cost looks wrong or unconfirmed, or before trusting any dollar figure for an Azure resource in this project — guessed pricing has been wrong here before (e.g. Azure SQL Managed Instance was guessed at $1.10-2.74/hr, actually $0.61/hr), so any number entering this catalog must be sourced, not recalled from memory.
---

# Research a pricing hint for one Azure resource type

This project's `config/resource-types.json` catalog has a `cost` object on every entry, auto-computed by `fetch-resource-pricing.ps1` from `config/pricing-hints.json`. That script can only do the part Azure exposes as structured, queryable data (the live rate). It cannot discover a service's genuine mandatory minimum purchase quantity, or which exact meter among many belongs to this catalog's chosen SKU — those live only in documentation prose or require picking the right one out of many API rows, and someone has to look. That's this skill's job: research one `armType`, end-to-end, and hand back a hint entry a human can review and drop straight into `config/pricing-hints.json`.

Do this research fresh every time — don't reuse a number from memory or from a prior conversation, even if it sounds familiar. Prices and SKUs change, and this catalog has already been burned once by that shortcut.

## Inputs

You'll be given an `armType` (e.g. `Microsoft.Sql/managedInstances`) or a plain Azure service name. If you weren't also given the catalog entry's requestBody, read it yourself: search `config/resource-types.json` for that `armType` (it's a JSON array under `resourceTypes`, matched by the `armType` field — check both the top-level entries and, if relevant, nested `prerequisites`). The exact SKU/tier/vCore-count/VM-size in that requestBody is what determines the real price, not "whatever the cheapest option in general is."

## Step 1 — does this even bill hourly?

Many Azure resources have no meaningful idle cost at all: pure metadata/container resources (e.g. restore point collections), consumption-billed services (pay only when you use them — Logic Apps, Functions, Cosmos DB serverless), and resources whose control plane is free with cost living entirely in child resources (an AKS cluster's control plane vs. its node pools; a Synapse workspace vs. its SQL pools). Forcing an hourly number onto these would be exactly the kind of guess this project is trying to eliminate.

Check Microsoft Learn / the service's azure.microsoft.com/pricing/details/ page for how the service actually bills. If it's genuinely free or purely consumption-based with no baseline, that's a valid, useful finding — say so explicitly, quote the source, and stop here. Don't invent an hourly hint just because one was requested. (`config/resource-types.json`'s existing notes for `Microsoft.ServiceFabric/clusters` and `Microsoft.Synapse/workspaces` are good examples of this exact finding, already sourced and written up.)

## Step 2 — find the real rate

If it does bill hourly (or per-unit-hour — per vCore, per capacity unit, per node), query the Azure Retail Prices API — unauthenticated, public, no auth needed:

```
https://prices.azure.com/api/retail/prices?$filter=armRegionName eq '<region>' and serviceName eq '<service>' and priceType eq 'Consumption'
```

Use the region this repo actually deploys to (check `src/AzResourceDetailsDownloader/appsettings.json`'s `Pipeline:DefaultLocation` rather than assuming). Fetch this with WebFetch or `curl` via Bash — it returns JSON with `meterName`, `productName`, `skuName`, `armSkuName`, `retailPrice`, `unitOfMeasure`, `meterId`. Narrow by adding `and contains(meterName, '...')` or inspect the full result set and filter client-side if the service has few enough meters.

Watch for these traps (both bit real research this session):
- **The same `skuName` can be reused across unrelated meters.** VPN Gateway's `VpnGw1AZ` SKU has both the real hourly gateway meter (`meterName: "VpnGw1AZ"`) and an unrelated per-connection add-on (`meterName: "S2S Connection"`) sharing that `skuName`. Match on `meterName`, not `skuName`, and double check what you matched actually represents the base deployment cost.
- **A short SKU name is often a substring of pricier variants.** VM meter names like `D2s v5` are also substrings of `D2s v5 Spot` and `D2s v5 Low Priority`. If you're writing a `meterNameContains` pattern for the hint file, make sure it wouldn't also match a Spot/Low-Priority/other variant you don't want — prefer the exact meterName as your pattern when there's any risk of this, and say so in `reason` if the risk exists.
- **Multiple meters can share an identical price without being ambiguous in effect.** Microsoft Fabric's capacity-unit rate is the same across every workload category (Power BI, Data Warehouse, Eventhouse, ...) — matching any one of them gives the right number. Don't waste time trying to find a single canonical "base" meter if several converge on the same figure; just confirm they agree and note that.
- **Some services genuinely aren't in the Retail Prices API at all.** Cosmos DB for MongoDB's vCore-cluster tiers (M10/M20/...) don't appear under any query variation tried this session. If exhaustive querying comes up empty, fall back to an official Microsoft blog/Learn page, cite it, and clearly mark the resulting figure as lower-confidence than an API-sourced one (the hint file's `manualPerHour`/`manualBillingUnit` fields exist for exactly this situation — see the schema note below).
- **A resource can have more than one real cost component, only one of which is knowable.** Azure Data Explorer Dev/Test clusters provision an engine node (priceable) plus an auto-sized data-management node whose price Microsoft doesn't publish per-SKU. Report what you found, flag what you couldn't find, and don't estimate the unknown part just to produce a single tidy number.

## Step 3 — find the real minimum purchase quantity (if any)

This is fundamentally different from Step 2's rate lookup: the Retail Prices API has no field for "smallest quantity you're allowed to buy" — that fact, when it exists, only lives in prose on Microsoft Learn or the service's pricing page. Search for it (WebSearch/WebFetch); look for sentences stating a hard floor ("a minimum of N units is required," "cannot be provisioned below X"). This is a fact about the *service itself*, not about what quantity this catalog's requestBody happens to use — e.g. Stream Analytics dedicated clusters can't be bought below 36 Streaming Units at all, which is different from "SQL Managed Instance's cheapest tier happens to start at 4 vCores but the catalog could choose more."

If you find a clear, quotable statement of a minimum, report it with the exact source sentence. If you don't find one — and most services don't have one; they simply have a cheapest available SKU — say "no confirmed minimum found" rather than guessing one. Leaving `minimumUnits` out of the hint entirely is the correct, honest outcome for most resource types.

## Step 4 — figure out the quantity path

If the price scales with a quantity that lives in the requestBody (vCores, capacity, node count), identify the JSON path to it (e.g. `sku.capacity`, `properties.coordinatorVCores`, `properties.count`) by reading the actual requestBody you found in the Inputs step. This becomes `quantityJsonPath` in the hint. If the resource is priced as a flat SKU with no independent quantity dimension (most dedicated-capacity services — Synapse pools, Managed HSM), omit this field.

## Output: a ready-to-paste hint entry

Produce one JSON object formatted for `config/pricing-hints.json`'s `hints` array. Match the shape already used by existing entries in that file — read a couple of them first for the exact field names and style. The core shape:

```json
{
  "armType": "Microsoft.Example/thing",
  "serviceName": "<serviceName value from the Retail Prices API, for the live lookup>",
  "meterNameContains": "<substring/exact meterName that isolates the right meter>",
  "productNameContains": "<optional, only if needed to disambiguate>",
  "quantityJsonPath": "<optional, e.g. 'sku.capacity'>",
  "minimumUnits": "<optional integer, only if Step 3 found a real, cited minimum>",
  "reason": "<cite everything: the exact API filter/fields you matched, or a URL + verbatim quote for any documentation claim. State your confidence level plainly, and flag anything left unresolved rather than papering over it.>"
}
```

If Step 2 couldn't resolve a reliable live API lookup (API coverage gap, or a genuinely multi-component cost you could only partially quantify), use `manualPerHour` and `manualBillingUnit` instead of `serviceName`/`meterNameContains` — this tells `fetch-resource-pricing.ps1` to use your researched number directly instead of attempting a live query, while making clear (via the field name itself) that it won't self-correct on future re-runs the way an API-backed hint would. Say so explicitly in `reason`, including what part (if any) is still missing.

If Step 1 concluded the resource has no genuine hourly cost, don't produce a hint entry at all — report your finding in prose with the source, and note that this armType should simply be left out of `pricing-hints.json` (absence is how "no idle cost" is represented; the fetch script gives entries without a hint a null cost, which is the honest answer, not a gap to fill).

## A note on confidence

Every entry in `config/resource-types.json`'s `notes` field that discusses cost already distinguishes "verified via X" from "reconstructed from general knowledge, not confirmed" — keep that same honesty in what you hand back. A clearly-labeled low-confidence finding is useful; a confident-sounding guess is what caused the original problem this catalog is trying to avoid repeating.
