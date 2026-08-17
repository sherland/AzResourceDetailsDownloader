using AzResourceDetailsDownloader.Reporting;

namespace AzResourceDetailsDownloader.Tests;

public class WorkerStatusBoardTests
{
    [Fact]
    public void Snapshot_InitialState_AllSlotsIdleAndZeroCompleted()
    {
        var board = new WorkerStatusBoard(slotCount: 3, totalItems: 10);

        var (slots, completed) = board.Snapshot();

        Assert.Equal(3, slots.Count);
        Assert.All(slots, s => Assert.Equal(WorkerStatus.Idle, s.Status));
        Assert.All(slots, s => Assert.Null(s.ArmType));
        Assert.All(slots, s => Assert.Equal(0, s.ProcessedCount));
        Assert.Equal(0, completed);
        Assert.Equal(10, board.TotalItems);
    }

    [Fact]
    public void SetRunning_UpdatesStatusAndArmTypeForThatSlotOnly()
    {
        var board = new WorkerStatusBoard(slotCount: 2, totalItems: 5);

        board.SetRunning(0, "Microsoft.KeyVault/vaults");

        var (slots, _) = board.Snapshot();
        Assert.Equal(WorkerStatus.Running, slots[0].Status);
        Assert.Equal("Microsoft.KeyVault/vaults", slots[0].ArmType);
        Assert.Equal(WorkerStatus.Idle, slots[1].Status);
    }

    [Fact]
    public void SetFinished_Success_MarksSucceededAndIncrementsProcessedCountAndCompleted()
    {
        var board = new WorkerStatusBoard(slotCount: 1, totalItems: 3);
        board.SetRunning(0, "Microsoft.KeyVault/vaults");

        board.SetFinished(0, success: true);

        var (slots, completed) = board.Snapshot();
        Assert.Equal(WorkerStatus.Succeeded, slots[0].Status);
        Assert.Equal(1, slots[0].ProcessedCount);
        Assert.Equal(1, completed);
    }

    [Fact]
    public void SetFinished_Failure_MarksFailed()
    {
        var board = new WorkerStatusBoard(slotCount: 1, totalItems: 3);
        board.SetRunning(0, "Microsoft.KeyVault/vaults");

        board.SetFinished(0, success: false);

        var (slots, _) = board.Snapshot();
        Assert.Equal(WorkerStatus.Failed, slots[0].Status);
    }

    // A slot is reused for many items over the life of one Parallel.ForEachAsync pass (see
    // Program.cs's slot-pool wrapper) — this is the steady-state behavior the live UI actually
    // renders, not just a single claim/release.
    [Fact]
    public void SetFinished_ThenSetRunningAgain_ProcessedCountAccumulatesAcrossSlotReuse()
    {
        var board = new WorkerStatusBoard(slotCount: 1, totalItems: 3);

        board.SetRunning(0, "type1");
        board.SetFinished(0, success: true);
        board.SetRunning(0, "type2");
        board.SetFinished(0, success: true);

        var (slots, completed) = board.Snapshot();
        Assert.Equal(2, slots[0].ProcessedCount);
        Assert.Equal(2, completed);
        Assert.Equal("type2", slots[0].ArmType);
    }

    [Fact]
    public void ConcurrentUpdatesAcrossManySlots_NeverThrowsAndCountsMatch()
    {
        const int slotCount = 8;
        const int itemsPerSlot = 50;
        var board = new WorkerStatusBoard(slotCount, slotCount * itemsPerSlot);

        Parallel.For(0, slotCount, slot =>
        {
            for (var i = 0; i < itemsPerSlot; i++)
            {
                board.SetRunning(slot, $"type{slot}-{i}");
                board.SetFinished(slot, success: i % 7 != 0);
            }
        });

        var (slots, completed) = board.Snapshot();
        Assert.Equal(slotCount * itemsPerSlot, completed);
        Assert.Equal(slotCount * itemsPerSlot, slots.Sum(s => s.ProcessedCount));
    }
}
