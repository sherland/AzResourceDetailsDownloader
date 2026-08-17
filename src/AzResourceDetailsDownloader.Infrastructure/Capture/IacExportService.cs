using System.Diagnostics;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using Azure.Core;
using AzResourceDetailsDownloader.Provisioning;
using Microsoft.Extensions.Logging;

namespace AzResourceDetailsDownloader.Capture;

// Captures the ephemeral resource group as Bicep and Terraform alongside the existing ARM JSON + screenshot.
// Both are exported at resource-group scope (not per-resource) so that a unit's prerequisites are captured
// together with its target in one call, with cross-resource references resolved as proper symbolic
// references (e.g. `azurerm_monitor_action_group.res-1.id`) rather than flat hardcoded IDs — verified live
// against a real multi-resource group before wiring this in.
public sealed partial class IacExportService(TokenCredential credential, RawArmClient rawArmClient) : IDisposable
{
    private static readonly string[] Scopes = ["https://management.azure.com/.default"];
    private const string TerraformApiVersion = "2025-06-01-preview";
    private static readonly TimeSpan TerraformPollInterval = TimeSpan.FromSeconds(3);
    private static readonly TimeSpan TerraformTimeout = TimeSpan.FromMinutes(5);

    private readonly HttpClient _httpClient = new();

    [GeneratedRegex("^[a-zA-Z0-9-]+$")]
    private static partial Regex ResourceGroupNamePattern();

    // Bicep has no equivalent ARM REST action for this — `az group export --export-format bicep` is the same
    // mechanism the portal's own "Export template" Bicep tab uses, so we shell out to the CLI the rest of this
    // tool already assumes is present (see AzCliContext), rather than reimplementing ARM-JSON-to-Bicep
    // decompilation ourselves.
    public async Task<string?> TryExportBicepAsync(string resourceGroupName, ILogger logger, CancellationToken ct = default)
    {
        // resourceGroupName is always tool-generated (rg-ardl-{guid:N}), but it still flows into a shell
        // command string below — validate rather than trust, since a shell-metacharacter check is cheap
        // insurance against ever building this into an injection vector.
        if (!ResourceGroupNamePattern().IsMatch(resourceGroupName))
        {
            throw new ArgumentException($"Unexpected resource group name '{resourceGroupName}'.", nameof(resourceGroupName));
        }

        var (fileName, arguments) = OperatingSystem.IsWindows()
            ? ("cmd.exe", $"/c az group export --resource-group {resourceGroupName} --export-format bicep -o tsv")
            : ("az", $"group export --resource-group {resourceGroupName} --export-format bicep -o tsv");

        try
        {
            var psi = new ProcessStartInfo(fileName, arguments)
            {
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true
            };

            using var process = Process.Start(psi)
                ?? throw new InvalidOperationException("Failed to start the 'az' process.");

            var stdoutTask = process.StandardOutput.ReadToEndAsync(ct);
            var stderrTask = process.StandardError.ReadToEndAsync(ct);
            await process.WaitForExitAsync(ct);
            var stdout = await stdoutTask;
            var stderr = await stderrTask;

            if (process.ExitCode != 0)
            {
                logger.LogWarning(
                    "  bicep export for resource group '{RgName}' failed (exit {ExitCode}): {Error}",
                    resourceGroupName, process.ExitCode, stderr.Trim());
                return null;
            }

            return stdout;
        }
        catch (Exception ex) when (ex is not OperationCanceledException)
        {
            logger.LogWarning(ex, "  bicep export for resource group '{RgName}' failed.", resourceGroupName);
            return null;
        }
    }

    public async Task<string?> TryExportTerraformAsync(
        string subscriptionId, string resourceGroupName, ILogger logger, CancellationToken ct = default)
    {
        try
        {
            return await TryExportTerraformCoreAsync(subscriptionId, resourceGroupName, logger, ct);
        }
        catch (Exception ex) when (ex is not OperationCanceledException)
        {
            logger.LogWarning(ex, "  terraform export for resource group '{RgName}' failed.", resourceGroupName);
            return null;
        }
    }

    private async Task<string?> TryExportTerraformCoreAsync(
        string subscriptionId, string resourceGroupName, ILogger logger, CancellationToken ct,
        bool retriedAfterRegistration = false)
    {
        var requestBody = JsonSerializer.Serialize(new
        {
            resourceGroupName,
            targetProvider = "azurerm",
            type = "ExportResourceGroup"
        });

        var token = await credential.GetTokenAsync(new TokenRequestContext(Scopes), ct);
        using var request = new HttpRequestMessage(
            HttpMethod.Post,
            $"https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.AzureTerraform/exportTerraform?api-version={TerraformApiVersion}")
        {
            Content = new StringContent(requestBody, Encoding.UTF8, "application/json")
        };
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token.Token);

        using var response = await _httpClient.SendAsync(request, ct);
        if (response.StatusCode != System.Net.HttpStatusCode.Accepted)
        {
            var body = await response.Content.ReadAsStringAsync(ct);

            // Same one-time auto-fix ResourceTypePipeline already applies to the main ARM PUT flow —
            // Microsoft.AzureTerraform just returns a differently-worded error for the same underlying
            // "never used this provider before" condition. Only ever retried once (retriedAfterRegistration
            // guards it) so a genuinely broken registration can't loop.
            if (!retriedAfterRegistration
                && ResourceProviderRegistrationErrorDetector.TryGetUnregisteredNamespace(body, out var ns))
            {
                logger.LogWarning(
                    "  terraform export needs resource provider '{Namespace}', which isn't registered on this subscription yet — registering it now (one-time, no-cost) and retrying.",
                    ns);
                await rawArmClient.RegisterResourceProviderAsync(subscriptionId, ns, ct);
                return await TryExportTerraformCoreAsync(subscriptionId, resourceGroupName, logger, ct, retriedAfterRegistration: true);
            }

            logger.LogWarning(
                "  terraform export for resource group '{RgName}' failed to start ({StatusCode}): {Body}",
                resourceGroupName, (int)response.StatusCode, body);
            return null;
        }

        // The async-operation URL carries a signed query string that must be reused verbatim — it is not
        // safe to reconstruct from just the operation id (confirmed live: a hand-built URL 404s).
        var operationUrl = response.Headers.TryGetValues("Azure-AsyncOperation", out var values)
            ? values.FirstOrDefault()
            : null;
        if (operationUrl is null)
        {
            logger.LogWarning(
                "  terraform export for resource group '{RgName}' returned 202 with no Azure-AsyncOperation header.",
                resourceGroupName);
            return null;
        }

        return await PollTerraformOperationAsync(operationUrl, resourceGroupName, logger, ct);
    }

    private async Task<string?> PollTerraformOperationAsync(
        string operationUrl, string resourceGroupName, ILogger logger, CancellationToken ct)
    {
        var deadline = DateTime.UtcNow + TerraformTimeout;
        while (true)
        {
            using var request = new HttpRequestMessage(HttpMethod.Get, operationUrl);
            var token = await credential.GetTokenAsync(new TokenRequestContext(Scopes), ct);
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token.Token);

            using var response = await _httpClient.SendAsync(request, ct);
            var body = await response.Content.ReadAsStringAsync(ct);
            using var doc = JsonDocument.Parse(body);
            var status = doc.RootElement.TryGetProperty("status", out var statusEl) ? statusEl.GetString() : null;

            if (string.Equals(status, "Succeeded", StringComparison.OrdinalIgnoreCase))
            {
                if (!doc.RootElement.TryGetProperty("properties", out var props))
                {
                    return null;
                }

                var configuration = props.TryGetProperty("configuration", out var cfg) ? cfg.GetString() : null;
                var import = props.TryGetProperty("import", out var imp) ? imp.GetString() : null;

                if (props.TryGetProperty("skippedResources", out var skipped) && skipped.ValueKind == JsonValueKind.Array
                    && skipped.GetArrayLength() > 0)
                {
                    logger.LogWarning(
                        "  terraform export for resource group '{RgName}' skipped some resources: {Skipped}",
                        resourceGroupName, skipped.GetRawText());
                }

                return string.Join("\n\n", new[] { configuration, import }.Where(s => !string.IsNullOrEmpty(s)));
            }

            if (string.Equals(status, "Failed", StringComparison.OrdinalIgnoreCase))
            {
                logger.LogWarning(
                    "  terraform export for resource group '{RgName}' ended in state 'Failed': {Body}",
                    resourceGroupName, body);
                return null;
            }

            if (DateTime.UtcNow >= deadline)
            {
                logger.LogWarning(
                    "  terraform export for resource group '{RgName}' timed out after {Timeout}.",
                    resourceGroupName, TerraformTimeout);
                return null;
            }

            await Task.Delay(TerraformPollInterval, ct);
        }
    }

    public void Dispose() => _httpClient.Dispose();
}
