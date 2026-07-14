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
    Azure AD tenant to log into. Defaults to this project's tenant.
#>
param(
    [string]$TenantId = "8b87af7d-8647-4dc7-8df4-5f69a2011bb5"
)

$ErrorActionPreference = "Stop"

Write-Host "== Step 1/3: az logout ==" -ForegroundColor Cyan
az logout 2>$null | Out-Null

Write-Host "== Step 2/3: az login (tenant $TenantId) ==" -ForegroundColor Cyan
az login --tenant $TenantId --scope "https://management.azure.com//.default"
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
