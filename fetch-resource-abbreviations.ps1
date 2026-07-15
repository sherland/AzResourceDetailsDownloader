<#
.SYNOPSIS
    Fetches Microsoft's official Azure resource-naming abbreviation reference table and writes it
    as a flat, structured JSON file for this tool to use when categorizing its own output.

.DESCRIPTION
    Source: https://github.com/MicrosoftDocs/cloud-adoption-framework/blob/main/docs/ready/azure-best-practices/resource-abbreviations.md
    The raw markdown (not the rendered Learn page) is fetched, since it's a stable, simple format:
    14 "## " category headers, each immediately followed by a 3-column pipe table
    (Resource | Resource provider namespace | Abbreviation). Some namespace cells carry a trailing
    "(kind: `X`)" qualifier distinguishing multiple rows that share the same ARM type
    (e.g. Microsoft.CognitiveServices/accounts) — this is split into its own field, not discarded.

.PARAMETER SourceUrl
    The raw markdown URL to fetch. Overridable for testing against a fork/branch.

.PARAMETER ConfigPath
    Where to write the parsed JSON. Defaults to config/resource-abbreviations.json next to this script.
#>
param(
    [string]$SourceUrl = "https://raw.githubusercontent.com/MicrosoftDocs/cloud-adoption-framework/main/docs/ready/azure-best-practices/resource-abbreviations.md",
    [string]$ConfigPath = (Join-Path $PSScriptRoot "config/resource-abbreviations.json")
)

$ErrorActionPreference = "Stop"

function ConvertFrom-AbbreviationsMarkdown {
    param([string]$MarkdownText)

    $entries = [System.Collections.Generic.List[object]]::new()
    $currentCategory = $null
    $inTable = $false

    foreach ($line in ($MarkdownText -split "`r?`n")) {
        if ($line -match '^##\s+(.+?)\s*$') {
            $currentCategory = $matches[1]
            $inTable = $false
            continue
        }

        if ($null -eq $currentCategory) { continue }

        # Table header row, e.g. "| Resource | Resource provider namespace | Abbreviation |"
        if ($line -match '^\|\s*Resource\s*\|') {
            $inTable = $true
            continue
        }

        # Separator row, e.g. "|--|--|--|"
        if ($line -match '^\|\s*:?-+:?\s*\|') {
            continue
        }

        if (-not $inTable) { continue }

        if ($line -notmatch '^\|(.+)\|\s*$') {
            # Table has ended (blank line, prose, or next section reached before its own '##' matched above)
            $inTable = $false
            continue
        }

        $cells = ($matches[1] -split '\|') | ForEach-Object { $_.Trim() }
        if ($cells.Count -lt 3) { continue }

        $resource = $cells[0]
        $namespaceRaw = $cells[1]
        $abbreviation = $cells[2] -replace '`', ''

        $resourceProviderNamespace = $null
        $kindQualifier = $null
        if ($namespaceRaw -match '^`([^`]+)`\s*(\(.*\))?\s*$') {
            $resourceProviderNamespace = $matches[1]
            if ($matches[2]) {
                $kindQualifier = $matches[2].Trim() -replace '^\(|\)$', ''
            }
        }
        else {
            $resourceProviderNamespace = $namespaceRaw -replace '`', ''
        }

        $entries.Add([PSCustomObject][ordered]@{
            category                  = $currentCategory
            resource                  = $resource
            resourceProviderNamespace = $resourceProviderNamespace
            kindQualifier              = $kindQualifier
            abbreviation               = $abbreviation
        })
    }

    return $entries
}

function Write-CategoryAmbiguityWarnings {
    param([System.Collections.Generic.List[object]]$Entries)

    # A namespace with multiple rows sharing the same category (kind-qualified variants, e.g. Cognitive
    # Services) is expected and fine. Flagging only the rarer case where the *same* namespace has genuinely
    # different categories with nothing (not even a kind) to disambiguate — the C# CategoryResolver picks the
    # entry with the shorter/more generic Resource name for these, but that's a tie-break, not a real answer,
    # so it's worth surfacing here rather than only discoverable by reading that code.
    $grouped = $Entries | Group-Object -Property resourceProviderNamespace
    foreach ($group in $grouped) {
        $distinctCategories = $group.Group | Select-Object -ExpandProperty category -Unique
        if ($distinctCategories.Count -le 1) { continue }

        Write-Warning "Ambiguous category for '$($group.Name)' — multiple entries with no kind qualifier to tell them apart:"
        foreach ($entry in $group.Group) {
            Write-Warning "  - '$($entry.resource)' -> $($entry.category) (abbreviation '$($entry.abbreviation)')"
        }
        $preferred = $group.Group | Sort-Object { $_.resource.Length } | Select-Object -First 1
        Write-Warning "  CategoryResolver will use: $($preferred.category) (shortest/most generic Resource name)"
    }
}

Write-Host "Fetching $SourceUrl ..."
$markdown = (Invoke-WebRequest -Uri $SourceUrl -UseBasicParsing).Content

$entries = ConvertFrom-AbbreviationsMarkdown -MarkdownText $markdown
if ($entries.Count -eq 0) {
    Write-Error "Parsed zero entries from the fetched markdown — the source format may have changed. Aborting without overwriting $ConfigPath."
    exit 1
}

Write-CategoryAmbiguityWarnings -Entries $entries

$payload = [ordered]@{
    sourceUrl  = $SourceUrl
    fetchedUtc = (Get-Date).ToUniversalTime().ToString("o")
    entries    = $entries
}

$configDir = Split-Path -Parent $ConfigPath
if ($configDir -and -not (Test-Path $configDir)) {
    New-Item -ItemType Directory -Force -Path $configDir | Out-Null
}

$payload | ConvertTo-Json -Depth 6 | Set-Content -Path $ConfigPath -Encoding utf8

$categoryCount = ($entries | Select-Object -ExpandProperty category -Unique).Count
Write-Host "Wrote $($entries.Count) entries across $categoryCount categories to $ConfigPath"
