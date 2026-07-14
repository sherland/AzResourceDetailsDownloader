using System.Diagnostics;
using System.Text.Json;

namespace AzResourceDetailsDownloader.Provisioning;

public sealed record AzCliAccount(string TenantId, string SubscriptionId);

public static class AzCliContext
{
    public static async Task<AzCliAccount> ResolveAsync(CancellationToken ct = default)
    {
        var (fileName, arguments) = OperatingSystem.IsWindows()
            ? ("cmd.exe", "/c az account show -o json")
            : ("az", "account show -o json");

        var psi = new ProcessStartInfo(fileName, arguments)
        {
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        using var process = Process.Start(psi)
            ?? throw new InvalidOperationException("Failed to start the 'az' process — is Azure CLI installed and on PATH?");

        var stdoutTask = process.StandardOutput.ReadToEndAsync(ct);
        var stderrTask = process.StandardError.ReadToEndAsync(ct);
        await process.WaitForExitAsync(ct);
        var stdout = await stdoutTask;
        var stderr = await stderrTask;

        if (process.ExitCode != 0)
        {
            throw new InvalidOperationException(
                $"'az account show' failed (exit {process.ExitCode}). Run 'az login' first. Details: {stderr}");
        }

        using var doc = JsonDocument.Parse(stdout);
        var tenantId = doc.RootElement.GetProperty("tenantId").GetString()
            ?? throw new InvalidOperationException("'az account show' output had no tenantId.");
        var subscriptionId = doc.RootElement.GetProperty("id").GetString()
            ?? throw new InvalidOperationException("'az account show' output had no subscription id.");

        return new AzCliAccount(tenantId, subscriptionId);
    }
}
