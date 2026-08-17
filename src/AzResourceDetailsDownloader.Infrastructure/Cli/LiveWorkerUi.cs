using AzResourceDetailsDownloader.Reporting;
using Spectre.Console;

namespace AzResourceDetailsDownloader.Cli;

// Renders a WorkerStatusBoard as a live-updating Spectre.Console table + log panel while `work`
// runs. The refresh loop is a plain timer racing alongside `work` — it only ever reads
// WorkerStatusBoard.Snapshot()/LogRingBuffer.Snapshot(), never anything that could block or slow
// worker execution. Wraps exactly one Parallel.ForEachAsync pass (see Program.cs) so it can be sized
// to that pass's own concurrency — the main run and the quota-retry pass use different concurrency
// levels, so each gets its own LiveWorkerUi.RunAsync call.
public static class LiveWorkerUi
{
    private static readonly TimeSpan RefreshInterval = TimeSpan.FromMilliseconds(250);

    // AnsiConsole.Live's own StartAsync wraps rendering in a try/finally that restores the terminal
    // (cursor, alt-buffer state) on the way out, whether `work` completes normally, throws, or is
    // cancelled — so a Ctrl+C or an unhandled exception mid-run still leaves the terminal usable
    // afterward rather than stuck mid-repaint.
    //
    // Live-observed (verifying this class against fake workers, no real Azure calls involved):
    // AnsiConsole.Live's Started() hook calls Console.CursorVisible = false before `work` ever runs
    // at all, and that throws IOException on a console that doesn't support cursor-visibility control
    // — independent of Console.IsOutputRedirected, which Program.cs already checks before enabling
    // --live-ui and did NOT predict this failure. A display-only fault must never take the whole
    // batch run down with it, so a failure to even *start* Live falls back to running `work` with no
    // live chrome. Guarded by `workStarted` so this fallback can only fire before `work` has been
    // entered — a fault *after* that point must propagate normally, not silently re-invoke `work`
    // (which would re-run real provisioning/capture side effects a second time).
    public static async Task RunAsync(WorkerStatusBoard board, LogRingBuffer logBuffer, string phaseLabel, Func<Task> work)
    {
        var layout = new Layout("root")
            .SplitRows(
                new Layout("workers"),
                new Layout("stats").Size(3),
                new Layout("log").Size(12));

        var workStarted = false;
        try
        {
            await AnsiConsole.Live(layout).StartAsync(async ctx =>
            {
                using var refreshCts = new CancellationTokenSource();
                var refreshTask = RefreshLoopAsync(ctx, layout, board, logBuffer, phaseLabel, refreshCts.Token);
                try
                {
                    workStarted = true;
                    await work();
                }
                finally
                {
                    await refreshCts.CancelAsync();
                    try
                    {
                        await refreshTask;
                    }
                    catch
                    {
                        // Best-effort: a rendering-loop fault after `work` already finished shouldn't
                        // change the run's outcome or mask its real result.
                    }

                    try
                    {
                        Render(layout, board, logBuffer, phaseLabel);
                        ctx.Refresh();
                    }
                    catch
                    {
                        // Best-effort final paint — ignore.
                    }
                }
            });
        }
        catch (Exception ex) when (!workStarted)
        {
            Console.Error.WriteLine(
                $"Live UI failed to start ({ex.GetType().Name}: {ex.Message}); continuing without it.");
            await work();
        }
    }

    private static async Task RefreshLoopAsync(
        LiveDisplayContext ctx, Layout layout, WorkerStatusBoard board, LogRingBuffer logBuffer, string phaseLabel, CancellationToken ct)
    {
        try
        {
            while (!ct.IsCancellationRequested)
            {
                Render(layout, board, logBuffer, phaseLabel);
                ctx.Refresh();
                await Task.Delay(RefreshInterval, ct);
            }
        }
        catch (OperationCanceledException)
        {
            // Expected on shutdown — RunAsync's finally block does one last render after this.
        }
    }

    private static void Render(Layout layout, WorkerStatusBoard board, LogRingBuffer logBuffer, string phaseLabel)
    {
        var (slots, completed) = board.Snapshot();

        var table = new Table().Expand().Title($"[bold]{phaseLabel.EscapeMarkup()}[/]");
        table.AddColumn("Worker");
        table.AddColumn("Status");
        table.AddColumn("Current item");
        table.AddColumn("Processed");
        foreach (var slot in slots)
        {
            table.AddRow(
                slot.Slot.ToString(),
                StatusMarkup(slot.Status),
                (slot.ArmType ?? "-").EscapeMarkup(),
                slot.ProcessedCount.ToString());
        }

        layout["workers"].Update(table);

        var elapsed = board.Elapsed;
        var rate = elapsed.TotalSeconds > 0 ? completed / elapsed.TotalSeconds : 0;
        var remaining = board.TotalItems - completed;
        var statsText = $"Remaining: [bold]{remaining}[/]   Processed: [bold]{completed}[/]/{board.TotalItems}   " +
            $"Rate: [bold]{rate:F2}[/]/s   Elapsed: [bold]{elapsed:mm\\:ss}[/]";
        layout["stats"].Update(new Panel(new Markup(statsText)).Header("Queue"));

        var logText = string.Join("\n", logBuffer.Snapshot().TakeLast(11));
        layout["log"].Update(new Panel(logText.EscapeMarkup()).Header("Recent activity").Expand());
    }

    private static string StatusMarkup(WorkerStatus status) => status switch
    {
        WorkerStatus.Idle => "[grey]Idle[/]",
        WorkerStatus.Running => "[yellow]Running[/]",
        WorkerStatus.Succeeded => "[green]Succeeded[/]",
        WorkerStatus.Failed => "[red]Failed[/]",
        _ => status.ToString(),
    };
}
