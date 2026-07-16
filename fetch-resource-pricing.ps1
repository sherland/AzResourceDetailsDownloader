<#
.SYNOPSIS
    Fetches real Azure pricing (Retail Prices API) for every catalog entry that has a
    config/pricing-hints.json hint, and writes a structured `cost` object onto each entry in
    config/resource-types.json.

.DESCRIPTION
    This is deliberately only half of a two-phase design:
      1. Rate fetch (this script) — fully automatable, safe to re-run unattended any time prices
         may have changed. Queries the Retail Prices API per hint, reads the entry's own quantity
         out of its requestBody, and computes perHour / perHourAccumulated / tier.
      2. Minimum-quantity research (config/pricing-hints.json itself) — semi-automated, done once
         per service via the research-pricing-hint skill (or by hand), then treated as reviewed,
         hand-curated input to this script. The Retail Prices API has no field for a service's real
         mandatory minimum purchase quantity — that fact only exists in documentation prose — so
         this script never invents or overwrites `minimumUnits`; it only ever reads it.

    Entries with no hint in pricing-hints.json get `cost.tier = Free` and every other cost field
    left out — that's the honest "no idle cost" answer for the 115 metadata/consumption entries
    in this catalog, not a gap to fill in later.

    `tier` is always fully recomputed from real cost data, never carried over from the catalog's
    previous `cost.tier` value — see the tier-change changelog this script prints. Complexity/risk concerns
    (orphaned resource groups, low schema confidence, "not live-tested") are a separate concern,
    already tracked as prose in each entry's `notes` field — this script doesn't touch that.

.PARAMETER CatalogPath
    config/resource-types.json to update in place.

.PARAMETER HintsPath
    config/pricing-hints.json — hand-curated, read-only input to this script.

.PARAMETER AppSettingsPath
    Used only to read Pipeline:DefaultLocation as the default Azure region for pricing lookups.

.PARAMETER ArmRegionName
    Overrides the region read from AppSettingsPath, mainly for testing against a different region.
#>
param(
    [string]$CatalogPath = (Join-Path $PSScriptRoot "config/resource-types.json"),
    [string]$HintsPath = (Join-Path $PSScriptRoot "config/pricing-hints.json"),
    [string]$AppSettingsPath = (Join-Path $PSScriptRoot "src/AzResourceDetailsDownloader/appsettings.json"),
    [string]$ArmRegionName
)

$ErrorActionPreference = "Stop"

# Purely a function of $/hour — no complexity/risk exceptions. Anchored to this project's own
# researched figures: Redis Basic C0 ($0.02/hr) anchors Low; Bastion/VPN Gateway/AKS-node
# (~$0.11-0.21/hr) anchor Medium; Power BI A1/Synapse DW100c ($1.00-1.51/hr) anchor High;
# SQL Managed Instance and Managed HSM anchor VeryHigh.
function Get-CostTier {
    param([double]$EffectiveHourlyCost)
    if ($EffectiveHourlyCost -le 0) { return "Free" }
    if ($EffectiveHourlyCost -le 0.05) { return "Low" }
    if ($EffectiveHourlyCost -le 0.30) { return "Medium" }
    if ($EffectiveHourlyCost -le 1.60) { return "High" }
    return "VeryHigh"
}

# Converts a raw retail price into a true $/hour rate. Most meters in this catalog are already
# hourly ("1 Hour"/"1/Hour"), but several confirmed-real findings bill daily or monthly instead
# (SQL elastic pools: "1/Day"; Azure Monitor alert rules, DNS zone hosting, Front Door base fees:
# "1/Month") — treating those raw numbers as if they were already hourly would overstate cost by
# 24x-730x. $UnitOfMeasureHoursOverride lets a hint be explicit when the API's own unitOfMeasure
# string is ambiguous or non-standard (e.g. a bare "1") rather than guessing from the string alone.
# Returns $null (unresolved) if neither an override nor a recognized pattern applies — the caller
# must then either supply unitOfMeasureHours on the hint or fall back to manualPerHour, rather than
# silently trusting an unconvertible number.
function Get-HourlyEquivalentRate {
    param([decimal]$RetailPrice, [string]$UnitOfMeasure, $UnitOfMeasureHoursOverride)
    if ($UnitOfMeasureHoursOverride) {
        return $RetailPrice / [decimal]$UnitOfMeasureHoursOverride
    }
    if ([string]::IsNullOrWhiteSpace($UnitOfMeasure)) { return $null }
    if ($UnitOfMeasure -match '(?i)hour') { return $RetailPrice }
    if ($UnitOfMeasure -match '(?i)day') { return $RetailPrice / 24 }
    if ($UnitOfMeasure -match '(?i)month') { return $RetailPrice / 730 }
    return $null
}

function Get-JsonPathValue {
    param($Object, [string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return $null }
    $current = $Object
    foreach ($segment in ($Path -split '\.')) {
        if ($null -eq $current) { return $null }
        $current = $current.$segment
    }
    return $current
}

function Invoke-RetailPricesQuery {
    param([string]$ServiceName, [string]$Region)
    $filter = "armRegionName eq '$Region' and serviceName eq '$ServiceName' and priceType eq 'Consumption'"
    $uri = "https://prices.azure.com/api/retail/prices?`$filter=" + [Uri]::EscapeDataString($filter)
    $items = [System.Collections.Generic.List[object]]::new()
    while ($uri) {
        $response = Invoke-RestMethod -Uri $uri -Method Get -UseBasicParsing
        foreach ($item in $response.Items) { $items.Add($item) }
        $uri = $response.NextPageLink
    }
    return $items
}

# Resolves a hint down to a base rate (per-unit, before quantity multiplication) plus traceability
# fields. Returns $null (and records a warning) if the hint can't be resolved to a usable rate —
# the caller leaves cost fields null rather than guessing when this happens.
function Resolve-HintRate {
    param($Hint, [string]$Region, [System.Collections.Generic.List[string]]$Warnings)

    if ($Hint.manualPerHour) {
        # A hand-researched fallback for services the live API can't reliably price (coverage
        # gaps, or multi-component costs only partially quantifiable) — see the hint's own
        # "reason" field for why. Doesn't self-correct on re-runs the way an API-backed hint does.
        return [PSCustomObject]@{
            BaseRate      = [decimal]$Hint.manualPerHour
            HourlyRate    = [decimal]$Hint.manualPerHour
            BillingUnit   = $Hint.manualBillingUnit
            MeterId       = $null
            MeterName     = $null
            ProductName   = $null
            ArmRegionName = $null
        }
    }

    if (-not $Hint.serviceName) {
        $Warnings.Add("Hint for '$($Hint.armType)' has neither serviceName nor manualPerHour - skipped, cost left null.")
        return $null
    }

    # Some real meters (NAT Gateway, Azure Front Door base fees, DNS zone hosting) are tagged
    # "Global" or by "Zone N" rather than a real Azure region — armRegionNameOverride lets a hint
    # query against that instead of the default region, so these can stay API-driven/self-updating
    # rather than falling back to a hardcoded manualPerHour.
    $queryRegion = if ($Hint.armRegionNameOverride) { $Hint.armRegionNameOverride } else { $Region }
    $items = Invoke-RetailPricesQuery -ServiceName $Hint.serviceName -Region $queryRegion
    $candidates = @($items | Where-Object {
        ([string]::IsNullOrEmpty($Hint.meterNameContains) -or $_.meterName -like "*$($Hint.meterNameContains)*") -and
        ([string]::IsNullOrEmpty($Hint.productNameContains) -or $_.productName -like "*$($Hint.productNameContains)*") -and
        ([string]::IsNullOrEmpty($Hint.skuNameContains) -or $_.skuName -like "*$($Hint.skuNameContains)*") -and
        ([string]::IsNullOrEmpty($Hint.productNameExcludes) -or $_.productName -notlike "*$($Hint.productNameExcludes)*") -and
        ([string]::IsNullOrEmpty($Hint.meterNameEquals) -or $_.meterName -eq $Hint.meterNameEquals) -and
        ([string]::IsNullOrEmpty($Hint.skuNameEquals) -or $_.skuName -eq $Hint.skuNameEquals)
    })

    if ($candidates.Count -eq 0) {
        $Warnings.Add("Hint for '$($Hint.armType)': zero meters matched serviceName='$($Hint.serviceName)' meterNameContains='$($Hint.meterNameContains)' productNameContains='$($Hint.productNameContains)' skuNameContains='$($Hint.skuNameContains)' meterNameEquals='$($Hint.meterNameEquals)' skuNameEquals='$($Hint.skuNameEquals)' in region '$Region'.")
        return $null
    }

    $distinctPrices = @($candidates | Select-Object -ExpandProperty retailPrice -Unique)
    $chosen = $null
    if ($distinctPrices.Count -eq 1) {
        # Multiple meters can legitimately share one price (e.g. Microsoft Fabric's capacity-unit
        # rate is identical across every workload category) — not a real ambiguity, no warning.
        $chosen = $candidates | Select-Object -First 1
    }
    else {
        $summary = ($candidates | ForEach-Object { "$($_.meterName)=`$$($_.retailPrice)" }) -join '; '
        $Warnings.Add("Hint for '$($Hint.armType)': $($candidates.Count) meters matched with $($distinctPrices.Count) distinct prices - picking the shortest meterName as a tie-break (mirrors CategoryResolver's ambiguity precedent). Candidates: $summary")
        $chosen = $candidates | Sort-Object { $_.meterName.Length } | Select-Object -First 1
    }

    $hourlyRate = Get-HourlyEquivalentRate -RetailPrice ([decimal]$chosen.retailPrice) -UnitOfMeasure $chosen.unitOfMeasure -UnitOfMeasureHoursOverride $Hint.unitOfMeasureHours
    if ($null -eq $hourlyRate) {
        $Warnings.Add("Hint for '$($Hint.armType)': matched meter '$($chosen.meterName)' has unitOfMeasure '$($chosen.unitOfMeasure)', which isn't a recognized hour/day/month pattern - can't safely convert to an hourly rate. Add 'unitOfMeasureHours' to this hint (how many hours the retailPrice actually covers) or use manualPerHour instead. Cost left null for now.")
        return $null
    }

    return [PSCustomObject]@{
        BaseRate      = [decimal]$chosen.retailPrice
        HourlyRate    = $hourlyRate
        BillingUnit   = $chosen.unitOfMeasure
        MeterId       = $chosen.meterId
        MeterName     = $chosen.meterName
        ProductName   = $chosen.productName
        ArmRegionName = $chosen.armRegionName
    }
}

# The quantity to multiply a resolved rate by: the entry's own requestBody quantity (if the hint
# names a quantityJsonPath), floored at the service's real minimumUnits (if the hint has one).
function Get-EffectiveQuantity {
    param($Hint, $RequestBody)
    $actual = 1.0
    if ($Hint.quantityJsonPath) {
        $value = Get-JsonPathValue -Object $RequestBody -Path $Hint.quantityJsonPath
        if ($null -ne $value) { $actual = [double]$value }
    }
    $minimum = if ($Hint.minimumUnits) { [double]$Hint.minimumUnits } else { 0.0 }
    return [Math]::Max($actual, $minimum)
}

function Resolve-EntryRate {
    param($Hint, $RequestBody, [string]$Region, [System.Collections.Generic.List[string]]$Warnings)
    if (-not $Hint) { return $null }
    $rate = Resolve-HintRate -Hint $Hint -Region $Region -Warnings $Warnings
    if (-not $rate) { return $null }
    # A manualPerHour is already the final, hand-computed per-hour total (e.g. $0.096 for all 16
    # addresses in a /28 prefix) — minimumUnits on a manual hint is documentation only, describing
    # what that total already represents, never a further multiplier. Only API-driven hints (whose
    # rate is a true per-unit rate) get multiplied by the entry's effective quantity.
    $quantity = if ($Hint.manualPerHour) { 1.0 } else { Get-EffectiveQuantity -Hint $Hint -RequestBody $RequestBody }
    return [PSCustomObject]@{
        # PerUnitRate stays the raw, as-billed meter rate (e.g. $0.50/zone/month) for traceability —
        # BillingUnit documents its real granularity. PerHour/PerHourAccumulated are always true
        # $/hour figures (via HourlyRate), so tier math and cross-resource comparisons never have to
        # guess which fields are safe to compare.
        PerUnitRate   = $rate.BaseRate
        BillingUnit   = $rate.BillingUnit
        MinimumUnits  = if ($Hint.minimumUnits) { [int]$Hint.minimumUnits } else { $null }
        PerHour       = $rate.HourlyRate * [decimal]$quantity
        MeterId       = $rate.MeterId
        MeterName     = $rate.MeterName
        ProductName   = $rate.ProductName
        ArmRegionName = $rate.ArmRegionName
    }
}

Write-Host "Loading hints from $HintsPath ..."
$hintsPayload = Get-Content -Raw -Path $HintsPath | ConvertFrom-Json -Depth 20
$hintsByArmType = @{}
foreach ($hint in $hintsPayload.hints) {
    $hintsByArmType[$hint.armType] = $hint
}
Write-Host "Loaded $($hintsByArmType.Count) pricing hints."

$region = $ArmRegionName
if (-not $region) {
    if (Test-Path $AppSettingsPath) {
        $appSettings = Get-Content -Raw -Path $AppSettingsPath | ConvertFrom-Json
        $region = $appSettings.Pipeline.DefaultLocation
    }
    if (-not $region) { $region = "westeurope" }
}
Write-Host "Pricing region: $region"

Write-Host "Loading catalog from $CatalogPath ..."
$catalog = Get-Content -Raw -Path $CatalogPath | ConvertFrom-Json -Depth 30

$warnings = [System.Collections.Generic.List[string]]::new()
$tierChanges = [System.Collections.Generic.List[string]]::new()
# Shared across entries so an armType reused as both a top-level entry and a prerequisite (or by
# multiple prerequisites) only queries the Retail Prices API once.
$rateCache = @{}

function Get-CachedEntryRate {
    param($ArmType, $RequestBody)
    if ($rateCache.ContainsKey($ArmType)) { return $rateCache[$ArmType] }
    $hint = $hintsByArmType[$ArmType]
    $resolved = Resolve-EntryRate -Hint $hint -RequestBody $RequestBody -Region $region -Warnings $warnings
    $rateCache[$ArmType] = $resolved
    return $resolved
}

$newEntries = [System.Collections.Generic.List[object]]::new()

foreach ($entry in $catalog.resourceTypes) {
    $ownRate = Get-CachedEntryRate -ArmType $entry.armType -RequestBody $entry.requestBody

    $prereqTotal = 0.0
    $hasAnyPrereqCost = $false
    $newPrereqs = [System.Collections.Generic.List[object]]::new()
    foreach ($prereq in $entry.prerequisites) {
        $prereqRate = Get-CachedEntryRate -ArmType $prereq.armType -RequestBody $prereq.requestBody

        $newPrereq = [ordered]@{
            alias      = $prereq.alias
            armType    = $prereq.armType
            apiVersion = $prereq.apiVersion
        }
        if ($prereq.PSObject.Properties.Match('location').Count -gt 0) { $newPrereq.location = $prereq.location }
        if ($prereq.PSObject.Properties.Match('locationFallbacks').Count -gt 0) { $newPrereq.locationFallbacks = $prereq.locationFallbacks }
        $newPrereq.nameTemplate = $prereq.nameTemplate
        if ($prereq.PSObject.Properties.Match('nameRules').Count -gt 0) { $newPrereq.nameRules = $prereq.nameRules }
        $newPrereq.requestBody = $prereq.requestBody
        if ($prereq.PSObject.Properties.Match('estimatedProvisionMinutes').Count -gt 0) { $newPrereq.estimatedProvisionMinutes = $prereq.estimatedProvisionMinutes }
        if ($prereqRate) {
            $newPrereq.perHour = $prereqRate.PerHour
            $prereqTotal += [double]$prereqRate.PerHour
            $hasAnyPrereqCost = $true
        }
        $newPrereqs.Add([PSCustomObject]$newPrereq)
    }

    $perHourAccumulated = $null
    if ($ownRate -or $hasAnyPrereqCost) {
        $ownPerHour = if ($ownRate) { [double]$ownRate.PerHour } else { 0.0 }
        $perHourAccumulated = [decimal]($ownPerHour + $prereqTotal)
    }

    # Fold in provisioning time so a slow-but-cheap-per-hour resource (e.g. SQL Managed Instance,
    # ~4 hours to provision at $0.61/hr) lands in the tier its real total single-run cost
    # warrants, not just its bare hourly rate. Only elevates tier for genuinely slow entries
    # (>1 hour) — a fast resource's total cost for under an hour never exceeds its hourly rate, so
    # there's nothing to fold in for the common case.
    $effectiveForTier = 0.0
    if ($null -ne $perHourAccumulated) {
        $effectiveForTier = [double]$perHourAccumulated
        if ($entry.estimatedProvisionMinutes -and $entry.estimatedProvisionMinutes -gt 60) {
            $effectiveForTier = $effectiveForTier * ($entry.estimatedProvisionMinutes / 60.0)
        }
    }
    $tier = Get-CostTier -EffectiveHourlyCost $effectiveForTier

    if ($entry.cost -and $entry.cost.tier -and $entry.cost.tier -ne $tier) {
        $tierChanges.Add("$($entry.armType): $($entry.cost.tier) -> $tier")
    }

    $cost = [ordered]@{ tier = $tier }
    if ($ownRate) {
        if ($ownRate.BillingUnit) { $cost.billingUnit = $ownRate.BillingUnit }
        if ($null -ne $ownRate.PerUnitRate) { $cost.perUnitRate = $ownRate.PerUnitRate }
        if ($null -ne $ownRate.MinimumUnits) { $cost.minimumUnits = $ownRate.MinimumUnits }
        $cost.perHour = $ownRate.PerHour
        if ($ownRate.MeterId) { $cost.meterId = $ownRate.MeterId }
        if ($ownRate.MeterName) { $cost.meterName = $ownRate.MeterName }
        if ($ownRate.ProductName) { $cost.productName = $ownRate.ProductName }
        if ($ownRate.ArmRegionName) { $cost.armRegionName = $ownRate.ArmRegionName }
    }
    if ($null -ne $perHourAccumulated) {
        $cost.perHourAccumulated = $perHourAccumulated
    }

    $newEntry = [ordered]@{
        armType    = $entry.armType
        apiVersion = $entry.apiVersion
        cost       = [PSCustomObject]$cost
    }
    if ($entry.PSObject.Properties.Match('location').Count -gt 0) { $newEntry.location = $entry.location }
    if ($entry.PSObject.Properties.Match('locationFallbacks').Count -gt 0) { $newEntry.locationFallbacks = $entry.locationFallbacks }
    $newEntry.nameTemplate = $entry.nameTemplate
    if ($entry.PSObject.Properties.Match('nameRules').Count -gt 0) { $newEntry.nameRules = $entry.nameRules }
    $newEntry.requestBody = $entry.requestBody
    $newEntry.prerequisites = $newPrereqs
    if ($entry.PSObject.Properties.Match('notes').Count -gt 0) { $newEntry.notes = $entry.notes }
    if ($entry.PSObject.Properties.Match('estimatedProvisionMinutes').Count -gt 0) { $newEntry.estimatedProvisionMinutes = $entry.estimatedProvisionMinutes }
    if ($entry.PSObject.Properties.Match('slowProvisioning').Count -gt 0) { $newEntry.slowProvisioning = $entry.slowProvisioning }

    $newEntries.Add([PSCustomObject]$newEntry)
}

if ($warnings.Count -gt 0) {
    Write-Host ""
    Write-Host "Ambiguity / resolution warnings ($($warnings.Count)):"
    foreach ($w in $warnings) { Write-Warning $w }
}

Write-Host ""
Write-Host "Tier changes ($($tierChanges.Count)):"
foreach ($c in $tierChanges) { Write-Host "  $c" }

$newCatalog = [ordered]@{
    '$schemaVersion'  = $catalog.'$schemaVersion'
    pricingFetchedUtc = (Get-Date).ToUniversalTime().ToString("o")
    resourceTypes     = $newEntries
}

([PSCustomObject]$newCatalog) | ConvertTo-Json -Depth 30 | Set-Content -Path $CatalogPath -Encoding utf8

Write-Host ""
Write-Host "Wrote updated cost data for $($newEntries.Count) entries to $CatalogPath"
