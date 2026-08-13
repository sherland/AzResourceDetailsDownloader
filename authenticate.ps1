<#
.SYNOPSIS
    Refreshes both auth surfaces this tool needs: the Azure CLI (ARM/management-plane) session
    and the saved Azure Portal browser session (.auth/storage_state.json).

.DESCRIPTION
    This tenant enforces a conditional-access sign-in-frequency policy, so the `az` CLI session
    periodically expires (the symptom is an AADSTS70043 error) and needs a genuinely fresh
    interactive login — a plain `az login` alone can silently reuse an existing SSO session
    without resetting that clock, so this script always logs out first to force a real
    re-authentication. It then launches the tool's own `--login` mode to refresh the separate
    portal browser session, which does not share the CLI's login state.

.PARAMETER TenantId
    Azure AD tenant to log into. Defaults to whatever tenant the current (possibly stale) `az`
    session already points at — read before logging out, since logout discards that context.
    Pass explicitly to switch tenants.
#>
param(
    [string]$TenantId = ""
)

$ErrorActionPreference = "Stop"

if (-not $TenantId) {
    # Read the outgoing session's tenant before logout wipes it, so a plain re-run of this script
    # re-authenticates against the same tenant by default instead of guessing. No hardcoded fallback
    # here on purpose — this tool's own appsettings.json leaves Pipeline:TenantId null for the same
    # reason (resolve live, never bake in a specific tenant/subscription).
    $TenantId = az account show --query tenantId -o tsv 2>$null
}

Write-Host "== Step 1/3: az logout ==" -ForegroundColor Cyan
az logout 2>$null | Out-Null

if ($TenantId) {
    Write-Host "== Step 2/3: az login (tenant $TenantId) ==" -ForegroundColor Cyan
    az login --tenant $TenantId --scope "https://management.azure.com//.default"
} else {
    Write-Host "== Step 2/3: az login (no prior session found — pick tenant/account interactively) ==" -ForegroundColor Cyan
    az login --scope "https://management.azure.com//.default"
}
if ($LASTEXITCODE -ne 0) {
    Write-Error "az login failed — aborting before touching the portal session."
    exit 1
}

Write-Host "== Step 3/3: portal browser login ==" -ForegroundColor Cyan
Write-Host "A Chromium window will open — log in there (including MFA), then it closes itself."
$projectPath = Join-Path $PSScriptRoot "src/AzResourceDetailsDownloader/AzResourceDetailsDownloader.csproj"
dotnet run --project $projectPath -- --login
if ($LASTEXITCODE -ne 0) {
    Write-Error "Portal login did not complete successfully."
    exit 1
}

Write-Host "Both auth surfaces refreshed." -ForegroundColor Green
