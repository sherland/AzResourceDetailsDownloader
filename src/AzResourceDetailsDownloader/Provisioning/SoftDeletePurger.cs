using System.Diagnostics;
using System.Text.RegularExpressions;
using Microsoft.Extensions.Logging;

namespace AzResourceDetailsDownloader.Provisioning;

// These 4 catalog resource types have Azure soft-delete/purge-protection enabled by default. Deterministic
// naming (see DeterministicNaming) means a previous run's resource is still "reserved" under this exact name
// until purged — this proactively purges any old soft-deleted resource with the same name before creating,
// so a second run of one of these entries doesn't fail with a name-reserved error.
//
// Best-effort by design: each `az` command behaves differently for the "nothing to purge" case (live-tested
// — Key Vault errors with ResourceNotFound; App Configuration silently exits 0) so both are treated as fine.
// Only a genuinely unexpected failure is logged, and even that doesn't block the unit — the actual PUT will
// surface a clear error on its own if this didn't actually clear a reservation.
public static partial class SoftDeletePurger
{
    // Microsoft.KeyVault/vaults is deliberately absent: this tenant mandates enablePurgeProtection on every
    // vault (see DeterministicNaming's ExemptFromDeterminism), and a purge-protected vault can never actually
    // be purged before its ~90-day scheduledPurgeDate — attempting it here would just waste every retry
    // delay before failing every time, for no benefit. Key Vault uses genuine random naming instead (see
    // DeterministicNaming), so there's nothing of its own for it to collide with in the first place.
    private static readonly HashSet<string> PurgeableArmTypes = new(StringComparer.OrdinalIgnoreCase)
    {
        "Microsoft.CognitiveServices/accounts",
        "Microsoft.AppConfiguration/configurationStores",
        "Microsoft.ApiManagement/service"
    };

    // A resource torn down by a previous run can take a little while to actually transition into a
    // genuinely purgeable/soft-deleted state — this tool's own RG teardown is fire-and-forget
    // (WaitUntil.Started, not waited-to-completion) precisely for speed, so a purge attempted immediately
    // after can hit the resource mid-transition. Live-observed as HTTP "MethodNotAllowed" on Key Vault
    // (`Operation 'DeletedVaultPurge' is not allowed`), not as a clean "not found" — so it's retried a few
    // times rather than treated as instantly conclusive.
    private static readonly TimeSpan[] RetryDelays = [TimeSpan.FromSeconds(15), TimeSpan.FromSeconds(30), TimeSpan.FromSeconds(60)];

    public static bool IsPurgeable(string armType) => PurgeableArmTypes.Contains(armType);

    public static async Task PurgeIfSoftDeletedAsync(string armType, string name, string location, ILogger logger, CancellationToken ct)
    {
        if (!IsPurgeable(armType))
        {
            return;
        }

        // name/location come from this tool's own deterministic generation and catalog config, not external
        // input — but still validated before building a shell command string, as defense in depth.
        if (!SafeArgumentPattern().IsMatch(name) || !SafeArgumentPattern().IsMatch(location))
        {
            throw new ArgumentException($"Unexpected characters in purge arguments: name='{name}', location='{location}'.");
        }

        for (var attempt = 0; attempt <= RetryDelays.Length; attempt++)
        {
            var (succeededOrNothingToPurge, stderr) = await TryPurgeOnceAsync(armType, name, location, ct);
            if (succeededOrNothingToPurge)
            {
                return;
            }

            if (attempt == RetryDelays.Length)
            {
                logger.LogWarning(
                    "  soft-delete purge check for {ArmType} '{Name}' returned an unexpected result after {Attempts} attempts (continuing anyway): {Error}",
                    armType, name, attempt + 1, stderr.Trim());
                return;
            }

            logger.LogInformation(
                "  soft-delete purge for {ArmType} '{Name}' not ready yet, retrying in {Delay}s.",
                armType, name, RetryDelays[attempt].TotalSeconds);
            await Task.Delay(RetryDelays[attempt], ct);
        }
    }

    private static async Task<(bool Done, string Stderr)> TryPurgeOnceAsync(string armType, string name, string location, CancellationToken ct)
    {
        // Cognitive Services is the odd one out: its deleted-resource lookup is scoped to the *original*
        // resource group, not just subscription+location (confirmed live — `deletedAccounts.id` embeds the
        // original RG name, and `purge` requires --resource-group as a mandatory argument). Since that
        // original RG is this tool's own random-per-run ephemeral one, a fresh run has no way to know it in
        // advance — so this needs a find-then-purge lookup instead of a single fire-and-forget command like
        // the other types.
        if (armType == "Microsoft.CognitiveServices/accounts")
        {
            return await TryPurgeCognitiveServicesAsync(name, location, ct);
        }

        var azArgs = armType switch
        {
            "Microsoft.AppConfiguration/configurationStores" => $"appconfig purge --name {name} --location {location} -y",
            "Microsoft.ApiManagement/service" => $"apim deletedservice purge --service-name {name} --location {location}",
            _ => throw new UnreachableException()
        };

        var (exitCode, stderr) = await RunAzAsync(azArgs, ct);
        return (exitCode == 0 || LooksLikeNothingToPurge(stderr), stderr);
    }

    private static async Task<(bool Done, string Stderr)> TryPurgeCognitiveServicesAsync(string name, string location, CancellationToken ct)
    {
        var (listExitCode, listStdout, listStderr) =
            await RunAzWithStdoutAsync($"cognitiveservices account list-deleted --query \"[?name=='{name}'].id\" -o tsv", ct);

        if (listExitCode != 0)
        {
            return (false, listStderr);
        }

        var id = listStdout.Trim();
        if (id.Length == 0)
        {
            return (true, ""); // nothing soft-deleted under this name — nothing to purge
        }

        var match = CognitiveServicesDeletedIdPattern().Match(id);
        if (!match.Success)
        {
            return (false, $"Could not parse resource group from deleted-account id: {id}");
        }

        var originalRgName = match.Groups["rg"].Value;
        var (purgeExitCode, purgeStderr) = await RunAzAsync(
            $"cognitiveservices account purge --name {name} --location {location} --resource-group {originalRgName}", ct);
        return (purgeExitCode == 0 || LooksLikeNothingToPurge(purgeStderr), purgeStderr);
    }

    private static Task<(int ExitCode, string Stderr)> RunAzAsync(string azArgs, CancellationToken ct) =>
        RunProcessAsync(azArgs, ct);

    private static Task<(int ExitCode, string Stdout, string Stderr)> RunAzWithStdoutAsync(string azArgs, CancellationToken ct) =>
        RunProcessWithStdoutAsync(azArgs, ct);

    private static async Task<(int ExitCode, string Stderr)> RunProcessAsync(string azArgs, CancellationToken ct)
    {
        var (exitCode, _, stderr) = await RunProcessWithStdoutAsync(azArgs, ct);
        return (exitCode, stderr);
    }

    private static async Task<(int ExitCode, string Stdout, string Stderr)> RunProcessWithStdoutAsync(string azArgs, CancellationToken ct)
    {
        var (fileName, arguments) = OperatingSystem.IsWindows()
            ? ("cmd.exe", $"/c az {azArgs}")
            : ("az", azArgs);

        try
        {
            var psi = new ProcessStartInfo(fileName, arguments)
            {
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true
            };

            using var process = Process.Start(psi) ?? throw new InvalidOperationException("Failed to start the 'az' process.");
            var stdoutTask = process.StandardOutput.ReadToEndAsync(ct);
            var stderrTask = process.StandardError.ReadToEndAsync(ct);
            await process.WaitForExitAsync(ct);
            var stdout = await stdoutTask;
            var stderr = await stderrTask;

            return (process.ExitCode, stdout, stderr);
        }
        catch (Exception ex) when (ex is not OperationCanceledException)
        {
            return (-1, "", ex.Message);
        }
    }

    [GeneratedRegex(@"/resourceGroups/(?<rg>[^/]+)/deletedAccounts/", RegexOptions.IgnoreCase)]
    private static partial Regex CognitiveServicesDeletedIdPattern();

    private static bool LooksLikeNothingToPurge(string stderr) =>
        stderr.Contains("not found", StringComparison.OrdinalIgnoreCase)
        || stderr.Contains("does not exist", StringComparison.OrdinalIgnoreCase)
        || stderr.Contains("NotFound", StringComparison.Ordinal);

    [GeneratedRegex("^[a-zA-Z0-9-]+$")]
    private static partial Regex SafeArgumentPattern();
}
