using System.Diagnostics;

namespace AzResourceDetailsDownloader.Reporting;

public enum WorkerStatus
{
    Idle,
    Running,
    Succeeded,
    Failed,
}

public sealed record WorkerState(int Slot, WorkerStatus Status, string? ArmType, int ProcessedCount);

// Thread-safe snapshot store for the live worker UI (see Cli.LiveWorkerUi) — one instance per
// Parallel.ForEachAsync pass, sized to that pass's own concurrency (main run and the quota-retry
// pass use different concurrency levels, so each gets its own board). Slot identity is assigned by
// the caller (see Program.cs's slot-pool wrapper around each pass), not derived from anything
// Parallel.ForEachAsync itself exposes.
//
// Updated from inside worker bodies (SetRunning/SetFinished), read by the UI's own independent
// refresh timer via Snapshot() — deliberately just an array copy under a lock, no per-read
// computation, so rendering never adds latency to worker throughput.
public sealed class WorkerStatusBoard
{
    private readonly WorkerState[] _slots;
    private readonly Lock _lock = new();
    private readonly Stopwatch _stopwatch = Stopwatch.StartNew();
    private int _completed;

    public WorkerStatusBoard(int slotCount, int totalItems)
    {
        _slots = Enumerable.Range(0, slotCount)
            .Select(i => new WorkerState(i, WorkerStatus.Idle, null, 0))
            .ToArray();
        TotalItems = totalItems;
    }

    public int TotalItems { get; }

    public TimeSpan Elapsed => _stopwatch.Elapsed;

    public void SetRunning(int slot, string armType)
    {
        lock (_lock)
        {
            _slots[slot] = _slots[slot] with { Status = WorkerStatus.Running, ArmType = armType };
        }
    }

    public void SetFinished(int slot, bool success)
    {
        lock (_lock)
        {
            var prev = _slots[slot];
            _slots[slot] = prev with
            {
                Status = success ? WorkerStatus.Succeeded : WorkerStatus.Failed,
                ProcessedCount = prev.ProcessedCount + 1,
            };
        }

        Interlocked.Increment(ref _completed);
    }

    public (IReadOnlyList<WorkerState> Slots, int Completed) Snapshot()
    {
        lock (_lock)
        {
            return ((IReadOnlyList<WorkerState>)_slots.ToArray(), _completed);
        }
    }
}
