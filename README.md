# AzResourceDetailsDownloader

Provisions native Azure resources one at a time in an ephemeral resource group, captures each resource's raw ARM JSON, a full-page screenshot of its Azure Portal Overview blade, and Bicep/Terraform representations of the whole resource group, then tears the resource group down — producing a documentation asset set per resource type:

```
output/{armType}/data.json
output/{armType}/portal.png
output/{armType}/resource-group.bicep
output/{armType}/resource-group.tf
output/{armType}/notes.md          # only present if the portal showed a notice for this resource
```

`{armType}` is the resource's ARM type string, lowercased with `/` and `.` replaced by `_` (e.g. `Microsoft.Storage/storageAccounts` → `microsoft_storage_storageaccounts`).

The Bicep and Terraform files are exported at **resource-group scope**, not per-resource — since each unit's target and its prerequisites all live in that one ephemeral group, this captures the whole unit in one call with cross-resource references resolved as proper symbolic references (e.g. `action_group_id = azurerm_monitor_action_group.res-1.id`), not flat hardcoded IDs. Bicep export shells out to `az group export --export-format bicep` (the same mechanism behind the portal's own "Export template" Bicep tab). Terraform export calls the `Microsoft.AzureTerraform` resource provider's `exportTerraform` action directly — the same backend behind the portal's Terraform (preview) export tab, not the third-party `aztfexport` tool — which requires a one-time `az provider register --namespace Microsoft.AzureTerraform` on the subscription. Both exports are best-effort: a failure is logged as a warning and skipped rather than failing the whole unit, since the ARM JSON capture is the core artifact.

`notes.md` captures info/warning banners the portal shows on a resource's Overview blade — deprecation notices, security recommendations, breaking-change warnings (the kind of thing that led to adding `Microsoft.Cache/redisEnterprise` once `Microsoft.Cache/redis`'s own retirement banner was noticed). These render as `div.fxc-infoBox-container` elements with `role="status"` and the full message text in their `aria-label` attribute (found by live DOM inspection — the visible text nodes can be truncated/duplicated for layout, so the accessible-name attribute is the reliable source; two earlier guesses, `role="alert"` then `role="banner"`, were both wrong — the latter turned out to be the page's own header landmark, not a notification). Only written when at least one notice is found; a stale `notes.md` from a previous run is deleted if the banner is no longer present.

## Prerequisites

- .NET 10 SDK
- Azure CLI, logged in (`az login`) with a subscription that has Contributor access. Tenant/subscription are read from `az account show` unless overridden in `appsettings.json`.
- Playwright browser binaries. If not already installed on this machine:
  ```
  pwsh src/AzResourceDetailsDownloader/bin/Debug/net10.0/playwright.ps1 install chromium
  ```

## One-time portal login

Portal screenshots need an authenticated browser session. Run once (and again whenever it expires):

```
dotnet run --login
```

This opens a real (maximized, non-headless) Chromium window at `portal.azure.com` — log in there, including MFA. Once the URL shows you're past login, the session is saved to `.auth/storage_state.json` (gitignored) and reused headlessly by every subsequent `--run`. The whole batch reuses one browser session/tab rather than opening a new one per resource, which is what avoids re-triggering MFA.

### Both auth surfaces at once

The ARM/CLI session (`az login`) and the portal browser session above are two independent auth surfaces — either can expire without the other doing so. In a tenant with a conditional-access sign-in-frequency policy, the `az` CLI session expires periodically (symptom: `AADSTS70043`), and a plain `az login` can silently reuse an existing SSO session without actually resetting that clock. `authenticate.ps1` refreshes both properly in one go:

```
./authenticate.ps1
```

It runs `az logout` first (to force a genuine interactive re-auth, not a silent SSO reuse), then `az login`, then this tool's own `--login` mode for the portal session.

## Usage

```
dotnet run --dry-run                                   # preview the catalog, no Azure/Playwright calls
dotnet run --dry-run --max-cost-tier Free               # preview just the Free-tier entries
dotnet run --run --only Microsoft.Storage/storageAccounts               # provision+capture+teardown a single type
dotnet run --run --only "Microsoft.Storage/storageAccounts,Microsoft.KeyVault/vaults"   # or several, comma-separated
dotnet run --run --max-cost-tier Low                     # full batch at or below the Low cost tier
dotnet run --run                                         # full batch at the default tier (Medium, from appsettings.json)
dotnet run --run --max-concurrency 8                     # override how many units run at once
```

Cost tiers are `Free < Low < Medium < High`. Every run (`--dry-run` or `--run`) is filtered by `--max-cost-tier`, defaulting to whatever `Pipeline:MaxCostTier` is set to in `appsettings.json` (`Medium` by default — i.e. everything except genuinely very-high-cost/high-friction resources runs unattended by default; `High` requires explicitly passing `--max-cost-tier High`).

Provisioning timeouts are also configurable in `appsettings.json`: `Pipeline:DefaultProvisioningTimeoutMinutes` (10 by default) applies to any catalog entry without its own `estimatedProvisionMinutes`; `Pipeline:ProvisioningTimeoutHeadroomMinutes` (10 by default) is added on top of `estimatedProvisionMinutes` for slow types. Tune these without a rebuild if a specific resource type is running close to its timeout in your tenant/region.

### Concurrency

Units run concurrently, bounded by `Pipeline:MaxConcurrentUnits` in `appsettings.json` (4 by default) or `--max-concurrency <n>`. Each unit does its own ARM provisioning/polling independently — this is where the real time savings come from, since most of a unit's wall-clock time is spent waiting on Azure (a few seconds for a Storage Account, 15-45+ minutes for AKS/VPN Gateway/Firewall), not on anything this tool itself does. Portal screenshot capture is the one part that stays serialized: there's only one browser page/tab, reused deliberately across the whole batch to avoid re-triggering MFA, so `PortalCaptureService` queues concurrent capture requests behind an internal lock and services them one at a time — transparent to callers, and live-verified to not mix up screenshots between units. Log lines are prefixed with each unit's `armType` (e.g. `[Microsoft.Storage/storageAccounts]`) since they now interleave on the console.

Keep the default modest rather than maximizing it: compute-family resource types (VMs, AKS, VMSS) share the subscription's regional vCPU quota, so running many of them at once risks quota exhaustion, not just faster provisioning. Tune `--max-concurrency` down if you hit quota errors, or up if your subscription has headroom and you're mostly running lightweight resource types.

Two concurrency-induced failure modes are handled automatically, both found live rather than anticipated in advance:
- **Subscription quota exhaustion**: if a unit fails with a detected quota error (`QuotaErrorDetector` — Azure's `OperationNotAllowed`/`QuotaExceeded` codes), it's automatically retried once, after the main pass, at a lower `Pipeline:QuotaRetryConcurrency` (1 by default) — quota exhaustion is usually a symptom of too many compute-heavy units running at once, not a real per-unit failure, so a quieter retry pass alone often succeeds.
- **Transient ARM operation locks**: live-observed running units concurrently — a VPN Gateway operation in flight can make Azure's networking RP return `429 RetryableErrorDueToAnotherOperation` to completely unrelated VNet-touching operations elsewhere in the subscription (different resource group, different VNet). Since ARM's own error code is literally "RetryableError", `RawArmClient` now retries any 429 a few times with backoff (respecting `Retry-After` if Azure sends one) before giving up.

## Config: `config/resource-types.json`

**92 entries, spanning storage, compute, networking, databases, security/identity, monitoring, web/app hosting, containers, messaging, AI/cognitive services, and desktop virtualization. 90 are live-verified end-to-end in this tenant; 2 (see Known limitations) are blocked by tenant-specific Azure Policy, not bugs in the tool or catalog.**

Includes `Microsoft.Cache/redisEnterprise` + `Microsoft.Cache/redisEnterprise/databases` ("Azure Managed Redis") alongside the classic `Microsoft.Cache/redis` — the portal itself now shows a retirement notice on the classic type (new creation blocked from 2026-10-01, retirement 2028-09-30) recommending the newer offering, so both are captured while the classic type still works.

Each entry describes one ARM resource type: `armType`, a pinned `apiVersion`, `costTier`, `location` (`null` = default region; some types, like Action Groups or Private DNS Zones, legitimately require `"global"`), `nameTemplate` (+ `nameRules` for the random-name charset/length: `lowerAlnum`, `lowerAlnumDash`, or `hex` for GUID-shaped names), `requestBody` (the minimal valid ARM properties for that type), and an optional `prerequisites` list for resources that need other resources created first (e.g. a SQL Database needs a SQL Server; a Subnet needs a Virtual Network). Prerequisites are provisioned in the order listed, each with its own independent `location` (a prerequisite doesn't inherit the target's location — a "global" target must not force "global" onto a prerequisite that needs a real region, and vice versa), and a prerequisite may only reference prerequisites declared earlier in the same list.

Placeholders resolved inside `nameTemplate`/`requestBody`/`location` (including inside tag *keys*, not just values — resolution happens on the raw JSON text before parsing):
- `{rand8}` (or any digit) — a random string of that length, using the charset from `nameRules`.
- `{prereq.<alias>.id}` / `{prereq.<alias>.name}` / `{prereq.<alias>.location}` — the ARM ID/name/actual-deployed-location of an already-provisioned prerequisite.
- `{secret.<key>}` — resolved from the `Secrets` configuration section (environment variable `ARDL_Secrets__<key>`, or `appsettings.Development.json`, both outside source control). `subscriptionId` and `tenantId` are auto-populated by the pipeline itself; things like `sqlAdminPassword`/`vmAdminPassword` need to be supplied explicitly when running entries that require them.

### Location fallbacks

Any entry (target or prerequisite) can set `locationFallbacks: ["region1", "region2", ...]`, tried in order after `location` (or the default region) fails — but *only* on a known Azure capacity/availability error (`ManagedEnvironmentCapacityHeavyUsageError`, `AllocationFailed`, `ZonalAllocationFailed`, `OverconstrainedAllocationRequest`, `SkuNotAvailable`), never on a real validation or policy error, since that would just fail identically in every region. A fresh resource name is generated for each fallback attempt — live testing showed ARM's `location` is immutable on an existing resource name (a same-name retry in a different region gets `InvalidResourceLocation`), and that a failed resource can sit in a `ScheduledForDelete` state for ~45-60s before actually clearing, so reusing a new name sidesteps both; the abandoned same-named resource in the original region is cleaned up regardless by the unit's own ephemeral-resource-group teardown.

If a target depends on a prerequisite that might land in a fallback region, point the target's own `location` at `{prereq.<alias>.location}` instead of a fixed region (see `Microsoft.App/containerApps` in the catalog) — live testing confirmed some resource types require this explicitly: a Container App's `location` must match its Managed Environment's *actual* deployed location, not just any allowed region, or creation fails with `ManagedEnvironmentNotFound`.

Growing the catalog towards broader coverage is just adding entries to this file — no C# changes required.

### Types deliberately excluded

A cross-reference against a real-world Azure Resource Graph inventory (133 distinct resource types actually in use) turned up types that don't belong in this catalog at all, for a few different reasons:

**Can't be created via a simple ARM PUT** — derived, auto-provisioned, or dependent on a real external asset:
`Microsoft.ContainerRegistry/registries/repositories` (created by `docker push`, not ARM), `microsoft.sqlvirtualmachine/sqlvirtualmachines` and `microsoft.hybridcompute/machines(/extensions,/licenseprofiles)` (require a real VM/machine that ran an onboarding agent), `microsoft.network/networkwatchers` (auto-created per region), `microsoft.alertsmanagement/smartdetectoralertrules` (auto-created by App Insights), `microsoft.web/certificates` and `microsoft.domainregistration/domains` (need a real certificate/domain purchase), `microsoft.azureactivedirectory/b2cdirectories` and `.../ciamdirectories` (special billing-linked onboarding), `microsoft.certificateregistration/certificateorders`, `microsoft.saas/resources` (third-party), `microsoft.kubernetes/connectedclusters` (Arc-enabled Kubernetes — same class as Arc machines).

**Architecturally out of reach for this tool today** — mainly resources whose ARM body must reference their *own* not-yet-assigned resource ID (a "self" token the templating model doesn't support):
`Microsoft.Network/applicationGateways` (httpListeners/backend settings cross-reference the gateway's own sub-resource IDs), `microsoft.network/connections` (needs two fully-provisioned VPN/ExpressRoute gateways as prerequisites — 20-45 min each), `microsoft.network/networkwatchers/flowlogs` and `.../connectionmonitors` (depend on the uncreatable Network Watcher), `microsoft.network/virtualhubs` (needs a Virtual WAN + complex hub config).

**Deliberately skipped** — prohibitively expensive/slow infra, or low-value niche types (≤7 instances in the real-usage sample) with uncertain/unusually complex schemas: `microsoft.web/hostingenvironments` (App Service Environment — hours to provision, high fixed cost), `microsoft.aad/domainservices` (hours to provision, dedicated subnet + ongoing cost), `microsoft.powerbidedicated/capacities` (meaningful minimum hourly cost), `microsoft.web/sites/slots` (needs a Standard+ tier plan, cost-tier conflict with the Basic-tier plan reused elsewhere), `microsoft.containerregistry/registries/tasks` (needs a real build context) and `.../replications` (needs Premium-tier ACR), `microsoft.web/connections` (Logic Apps connector schemas vary wildly), plus a long tail of ≤5-instance niche types (Service Fabric, Defender for Cloud automations/connectors, Prometheus rule groups, alert processing rules, AI Studio projects, gallery image *versions*, etc.).

**Live-tested, not guessed** — three types were suspected obsolete/deprecated and actually tested against the real ARM API rather than assumed:
- `microsoft.bing/accounts` — **confirmed retired**. A real PUT attempt returns an explicit `ApiSetDisabledForCreation` error: *"Bing Search APIs are retired. New deployments are not supported."* Excluded with certainty.
- `microsoft.devtestlab/labs` — **not retired; actually creates successfully.** But testing it surfaced a real incompatibility with this tool's design: creating a lab auto-provisions a Storage Account and a Key Vault, each with a self-applied `CanNotDelete` management lock — which **Contributor-level access (this tool's stated requirement) cannot remove**. A generic "delete the resource group" teardown would leave the ephemeral RG permanently stuck. The lab's own DELETE API cascades correctly and removes the locks as part of its own cleanup, so this is fixable in principle (special-case the teardown for this one type, or delete the lab resource itself before the RG) — just not with the current generic per-unit pipeline, so it's excluded for now rather than risk a genuinely undeletable resource group.
- `microsoft.visualstudio/account` — **inconclusive.** Not blocked with a retirement-style error like Bing, and the resource provider is registrable, but every reasonable request body attempt (including supplying a real tenant GUID for the required `hostId` property, at both the top level and nested under `properties`) failed with `"The guid specified for parameter hostId must not be Guid.Empty"` — suggesting either an undocumented additional requirement or a create flow that's effectively non-functional via a direct ARM PUT today, even though not formally retired. Left excluded; Azure DevOps organizations are in practice created through other flows (the portal, `dev.azure.com`) rather than this legacy 2014-preview ARM resource anyway.

None of this is permanent — the catalog is just JSON, so any of these can be added later if there's a concrete need.

## Known limitations

- **Resource-provider registration**: a subscription that has never used a given Azure service needs that resource provider registered once (`az provider register --namespace Microsoft.X`) before the first resource of that type can be created there. This is a one-time, no-cost, reversible subscription setting, not something this tool does automatically.
- **Container Apps regional capacity (auto-mitigated)**: `Microsoft.App/managedEnvironments` can fail with `ManagedEnvironmentCapacityHeavyUsageError` — a genuine Azure-side "high demand in current region" condition (see `aka.ms/akscapacityheavyusage`), not a bug in this tool or a tenant policy; the same empty-properties request body succeeds fine most of the time. This is now handled automatically via `locationFallbacks` (see below) rather than requiring a manual re-run.
- **Tenant policy**: organizations often have Azure Policy guardrails (e.g. requiring `minimalTlsVersion`, `httpsOnly`, purge protection, or restricting resource-group regions) that reject a naively-minimal request body. `config/resource-types.json` entries were tuned against this project's actual tenant; a different tenant's policies may require further adjustments to specific `requestBody` values.
- **Portal interstitials**: the Azure Portal occasionally shows a promotional banner or an NPS survey popup over the Overview blade. The capture step doesn't try to dismiss these — they're a real (if rare) reason a `portal.png` might have an overlay in it.
- **Incomplete-render / "resource not found" screenshots (fixed)**: two distinct render-timing bugs were found and fixed via live testing. (1) A still-loading blade (shimmer placeholder or spinner) got screenshotted before content settled — fixed by waiting for common Fluent UI loading indicators (`role="progressbar"`, `aria-busy`, shimmer/skeleton/spinner classes) to clear, in addition to the "Essentials" text/heading marker. (2) A subtler race: the portal blade *chrome* (title) renders from the URL alone and can pass the heading check while the content panel still shows a genuine "The resource was not found" 404 (an ARM-to-portal propagation lag right after creation) — and that 404 state can itself only appear *after* the loading spinner clears, so checking for it before the spinner check made the check pass falsely. Fixed by moving the not-found check to run last, immediately before the screenshot, with a reload-and-retry loop. Verified across a full 90-entry re-verification pass: the not-found race recurred on 4 separate `Microsoft.Insights/*` alert-rule types and self-healed correctly every time, with zero bad screenshots reaching disk.
- **Hard crash / power loss**: the try/finally around each unit guarantees resource-group teardown for ordinary exceptions, but a hard process kill or power loss could still leave an ephemeral resource group behind. Also seen in practice: a resource-group delete can be *accepted* and briefly show `Deleting`, then silently fail in the background and revert to `Succeeded` — this tool doesn't poll delete-to-completion (a deliberate speed/simplicity tradeoff), so it's worth an occasional manual sweep. Every resource group created by this tool is tagged `purpose=az-resource-details-downloader`, so stragglers can be found and cleaned up with:
  ```
  az group list --tag purpose=az-resource-details-downloader -o table
  ```
- **`Microsoft.Compute/virtualMachines` — tenant naming/disk policies (fixed)**: this tenant's custom policies denied VM creation twice over — a naming-convention policy requiring names to start with `swaz`/`slaz` and end in two digits (for names ≤15 chars), and a separate disk-SKU policy rejecting the VM's auto-generated OS disk's default `Premium_LRS` (only `Standard_LRS`/`StandardSSD_LRS` are allowed). Both were decoded via `az policy definition show` and live reproduction rather than guessed from the error text, and both are now baked into the catalog entry (`nameTemplate: "swaz{rand9}01"`, explicit `osDisk.managedDisk.storageAccountType`) — fully live-verified end-to-end. These are tenant-specific values in catalog *config*, not portable defaults; a tenant without these policies works fine either way.
- **One entry blocked by tenant-specific Azure Policy with no possible workaround**: `Microsoft.Insights/autoscalesettings` — this tenant restricts App Service Plan SKUs to `F1/B1/B2/B3/Y1/FC1/Consumption`, none of which support autoscale (which genuinely requires Standard tier or higher in Azure) — so no request body can satisfy both constraints simultaneously in this tenant. Not a bug in this tool — a subscription without this policy should succeed with the body as-is.
- **Slow-provisioning entries** (all live-verified, but genuinely slow — expect a full unattended run at `--max-cost-tier Medium` or above to take well over an hour): `Microsoft.Cache/redis` (~15-25 min), `Microsoft.Network/virtualNetworkGateways` (~30-45 min, requires an AZ-suffixed SKU like `VpnGw1AZ` plus a zone-configured Public IP), `Microsoft.ContainerService/managedClusters`/AKS (~15 min, this tenant also restricts node-pool VM sizes to specific D-series SKUs), `Microsoft.Network/bastionHosts` (~8-10 min), `Microsoft.DBforPostgreSQL/flexibleServers` (~10-15 min), `Microsoft.Network/azureFirewalls` (~15-20 min; the Basic SKU specifically requires a separate Management IP configuration/subnet/public IP that Standard/Premium don't need), `Microsoft.DocumentDB/mongoClusters` (~10 min, no free/serverless tier), `Microsoft.Devices/IotHubs` (~5 min, but the F1 free SKU is capped at one per subscription).
- **ARM quirks worth knowing about if you extend the catalog further**: some resource types nest `sku` inside `properties` instead of alongside it (`Microsoft.Cache/redis`); some require region-specific VM SKU availability that varies over time (capacity errors aren't config bugs); a few resource names must be GUID-shaped (`Microsoft.Insights/workbooks` — use `nameRules.charset: "hex"` with a templated GUID pattern) or match other structural conventions the ARM API validates strictly (e.g. `Microsoft.Portal/dashboards`'s `properties.lenses` must be a JSON array, not an object).
