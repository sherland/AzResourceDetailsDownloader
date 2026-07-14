using System.Text.Json;

namespace AzResourceDetailsDownloader.Reporting;

public sealed class RunSummary
{
    private readonly List<RunResult> _results = [];

    public IReadOnlyList<RunResult> Results => _results;

    public void Add(RunResult result) => _results.Add(result);

    public async Task WriteAsync(string outputRoot, CancellationToken ct = default)
    {
        Directory.CreateDirectory(outputRoot);

        var payload = new
        {
            generatedUtc = DateTime.UtcNow.ToString("O"),
            total = _results.Count,
            succeeded = _results.Count(r => r.Success),
            failed = _results.Count(r => !r.Success),
            results = _results.Select(r => new
            {
                armType = r.ArmType,
                success = r.Success,
                elapsedSeconds = Math.Round(r.Elapsed.TotalSeconds, 1),
                error = r.Error
            })
        };

        var json = JsonSerializer.Serialize(payload, new JsonSerializerOptions { WriteIndented = true });
        await File.WriteAllTextAsync(Path.Combine(outputRoot, "summary.json"), json, ct);
    }
}
