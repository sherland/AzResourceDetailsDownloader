using Microsoft.Extensions.Logging;

namespace AzResourceDetailsDownloader.Cli;

// Bounded ring buffer of recently-formatted log lines. Exists only for the --live-ui path (see
// LiveWorkerUi): while a Spectre.Console Live display owns the terminal, per-unit log lines can't be
// raw-written to Console.Out the way they normally are (AddSimpleConsole) — that would corrupt the
// live-repainted region. RingBufferLoggerProvider below captures them here instead, and LiveWorkerUi
// renders the tail into its own panel, so the debugging signal isn't lost, just relocated.
public sealed class LogRingBuffer(int capacity = 200)
{
    private readonly Lock _lock = new();
    private readonly Queue<string> _lines = new(capacity);

    public void Add(string line)
    {
        lock (_lock)
        {
            _lines.Enqueue(line);
            while (_lines.Count > capacity)
            {
                _lines.Dequeue();
            }
        }
    }

    public IReadOnlyList<string> Snapshot()
    {
        lock (_lock)
        {
            return _lines.ToArray();
        }
    }
}

public sealed class RingBufferLoggerProvider(LogRingBuffer buffer) : ILoggerProvider
{
    public ILogger CreateLogger(string categoryName) => new RingBufferLogger(buffer);

    public void Dispose()
    {
    }

    private sealed class RingBufferLogger(LogRingBuffer buffer) : ILogger
    {
        public IDisposable? BeginScope<TState>(TState state) where TState : notnull => null;

        public bool IsEnabled(LogLevel logLevel) => logLevel >= LogLevel.Information;

        public void Log<TState>(
            LogLevel logLevel, EventId eventId, TState state, Exception? exception, Func<TState, Exception?, string> formatter)
        {
            if (!IsEnabled(logLevel))
            {
                return;
            }

            var line = formatter(state, exception);
            buffer.Add(exception is null ? line : $"{line} :: {exception.Message}");
        }
    }
}
