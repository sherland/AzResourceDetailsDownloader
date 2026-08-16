using System.Text.Json;

namespace AzResourceDetailsDownloader.Reporting;

// Add() is called concurrently once units run in parallel, so it's guarded by a lock — reads (Results,
// WriteAsync) are only ever called after all units have finished, once concurrent writes have stopped.
public sealed class RunSummary
{
    private readonly List<RunResult> _results = [];
    private readonly Lock _lock = new();

    public IReadOnlyList<RunResult> Results => _results;

    public void Add(RunResult result)
    {
        lock (_lock)
        {
            _results.Add(result);
        }
    }

    // Used by the quota-error retry pass: a unit that failed in the main run and is retried afterward should
    // replace its original (failed) entry, not add a second one for the same ArmType.
    public void ReplaceOrAdd(RunResult result)
    {
        lock (_lock)
        {
            _results.RemoveAll(r => r.ArmType == result.ArmType);
            _results.Add(result);
        }
    }

    public async Task WriteAsync(string outputRoot, CancellationToken ct = default)
    {
        Directory.CreateDirectory(outputRoot);

        // Surfaced separately from `results` so a silent Essentials-extraction regression across a
        // batch (a unit reports Success but FieldCount is 0) shows up in the summary itself, not
        // just as a line in console scrollback during the run — see AGENT.md for the incident this
        // is meant to catch a repeat of.
        var zeroFieldArmTypes = _results
            .Where(r => r is { Success: true, FieldCount: 0 })
            .Select(r => r.ArmType)
            .ToList();

        var payload = new
        {
            generatedUtc = DateTime.UtcNow.ToString("O"),
            total = _results.Count,
            succeeded = _results.Count(r => r.Success),
            failed = _results.Count(r => !r.Success),
            zeroFieldCount = zeroFieldArmTypes.Count,
            zeroFieldArmTypes,
            results = _results.Select(r => new
            {
                armType = r.ArmType,
                success = r.Success,
                elapsedSeconds = Math.Round(r.Elapsed.TotalSeconds, 1),
                error = r.Error,
                fieldCount = r.FieldCount
            })
        };

        var json = JsonSerializer.Serialize(payload, new JsonSerializerOptions { WriteIndented = true });
        await File.WriteAllTextAsync(Path.Combine(outputRoot, "summary.json"), json, ct);
    }
}
