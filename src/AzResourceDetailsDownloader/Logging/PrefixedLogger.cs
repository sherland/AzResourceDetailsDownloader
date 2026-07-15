using Microsoft.Extensions.Logging;

namespace AzResourceDetailsDownloader.Logging;

// Once units run concurrently, log lines from different units interleave — this prepends a short label
// (the ArmType) to every message so a human reading the console/file can tell them apart without having to
// change every individual LogInformation call site across the codebase.
public sealed class PrefixedLogger(ILogger inner, string prefix) : ILogger
{
    public IDisposable? BeginScope<TState>(TState state) where TState : notnull => inner.BeginScope(state);

    public bool IsEnabled(LogLevel logLevel) => inner.IsEnabled(logLevel);

    public void Log<TState>(LogLevel logLevel, EventId eventId, TState state, Exception? exception, Func<TState, Exception?, string> formatter) =>
        inner.Log(logLevel, eventId, state, exception, (s, e) => prefix + formatter(s, e));
}
