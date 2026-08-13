<#
.SYNOPSIS
    Fetches Azure reference/lookup data — region codes to portal display names today, and later
    other Azure-published catalogs (SKU metadata, resource-provider display names, ...) — and
    writes each as a structured JSON file under config/ for the C# tool to consume.

.DESCRIPTION
    Structured as a registry of named data-set fetchers ($DataSetDefinitions) rather than one
    fixed script: adding a new reference source later means adding one new registry entry (a
    Fetch scriptblock + an OutputFile name), not restructuring this file. Each fetcher receives
    the active subscription ID and returns a plain array of objects; this script handles the
    envelope (fetchedUtc), config path resolution, and writing.

    Uses `az rest` (the already-authenticated az CLI session) rather than the Az PowerShell
    module — matches how the rest of this repo authenticates (see authenticate.ps1 /
    AzCliContext.cs) and needs no extra module dependency.

    The subscription ID is used transiently to build request URLs and is never written to any
    output file — these are committed reference files, and ARM's responses embed the
    subscription ID inside `id` fields (its own and, for locations, each paired region's), which
    Get-*Entries strips before returning.

.PARAMETER DataSets
    Which registered data set(s) to fetch. Defaults to all registered sets. Pass a name from
    $DataSetDefinitions (e.g. -DataSets locations) to fetch just one.

.PARAMETER ConfigDir
    Directory each data set's JSON file is written into. Defaults to config/ next to this script.

.EXAMPLE
    pwsh ./fetch-azure-reference-data.ps1
    Fetches every registered data set.

.EXAMPLE
    pwsh ./fetch-azure-reference-data.ps1 -DataSets locations
    Fetches only the region display-name map.
#>
param(
    [string[]]$DataSets,
    [string]$ConfigDir = (Join-Path $PSScriptRoot "config")
)

$ErrorActionPreference = "Stop"

function Get-CurrentSubscriptionId {
    if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
        throw "Azure CLI ('az') not found on PATH — install it first."
    }
    $raw = az account show
    if ($LASTEXITCODE -ne 0) {
        throw "Not logged in to Azure CLI (or no subscription selected) — run 'az login' first."
    }
    return ($raw | ConvertFrom-Json).id
}

function Invoke-ArmRest {
    param([string]$Url)
    $raw = az rest --method get --url $Url
    if ($LASTEXITCODE -ne 0) {
        throw "ARM request failed (az exit code $LASTEXITCODE): $Url"
    }
    return $raw | ConvertFrom-Json -Depth 20
}

# Most ARM list APIs that can page do so via a "nextLink" property — reusable by any future
# fetcher in the registry below, even though today's only data set (locations) never actually
# pages. Falls back to a single Invoke-ArmRest call for endpoints that don't page at all.
function Invoke-ArmRestPaged {
    param([string]$Url)
    $items = [System.Collections.Generic.List[object]]::new()
    $next = $Url
    while ($next) {
        $response = Invoke-ArmRest -Url $next
        if ($response.value) {
            foreach ($item in $response.value) { $items.Add($item) }
        }
        $next = $response.nextLink
    }
    return $items
}

# ─────────────────────────────────────────────────────────────────────────
# Data-set registry — add a new entry here to fetch something else later.
# Each Fetch scriptblock receives $SubscriptionId and returns a plain array
# of objects (already stripped of anything subscription-specific);
# OutputFile is where that array is written, under $ConfigDir.
# ─────────────────────────────────────────────────────────────────────────

$DataSetDefinitions = [ordered]@{
    "locations" = @{
        Description = "Azure region codes -> portal display names (e.g. 'norwayeast' -> 'Norway East'), from the ARM Locations API."
        OutputFile  = "azure-locations.json"
        Fetch       = {
            param($SubscriptionId)
            $items = Invoke-ArmRestPaged -Url "https://management.azure.com/subscriptions/$SubscriptionId/locations?api-version=2022-12-01"
            # Physical regions only — the ~46 "Logical" entries (paired-region groupings, "Global",
            # geography rollups) aren't what an ARM resource's own `location` field ever contains.
            # `id` (this location's own and each paired region's) embeds the subscription ID and is
            # deliberately never copied into the output.
            return $items |
                Where-Object { $_.metadata.regionType -eq "Physical" } |
                ForEach-Object {
                    [PSCustomObject][ordered]@{
                        name                = $_.name
                        displayName         = $_.displayName
                        regionalDisplayName = $_.regionalDisplayName
                        geographyGroup      = $_.metadata.geographyGroup
                    }
                } |
                Sort-Object name
        }
    }
}

if (-not $DataSets -or $DataSets.Count -eq 0) {
    $DataSets = @($DataSetDefinitions.Keys)
}
foreach ($name in $DataSets) {
    if (-not $DataSetDefinitions.Contains($name)) {
        $known = ($DataSetDefinitions.Keys) -join ", "
        throw "Unknown data set '$name'. Known data sets: $known"
    }
}

if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Force -Path $ConfigDir | Out-Null
}

$subscriptionId = Get-CurrentSubscriptionId
Write-Host "Authenticated (subscription resolved, not persisted to any output file)."

foreach ($name in $DataSets) {
    $definition = $DataSetDefinitions[$name]
    Write-Host "Fetching '$name' — $($definition.Description)"

    $entries = @(& $definition.Fetch $subscriptionId)
    if ($entries.Count -eq 0) {
        Write-Warning "Fetched zero entries for '$name' — not overwriting its existing output file."
        continue
    }

    $payload = [ordered]@{
        dataSet    = $name
        fetchedUtc = (Get-Date).ToUniversalTime().ToString("o")
        entries    = $entries
    }

    $outputPath = Join-Path $ConfigDir $definition.OutputFile
    $payload | ConvertTo-Json -Depth 10 | Set-Content -Path $outputPath -Encoding utf8
    Write-Host "  Wrote $($entries.Count) entries to $outputPath"
}
