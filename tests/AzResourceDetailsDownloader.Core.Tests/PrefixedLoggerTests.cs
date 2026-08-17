using AzResourceDetailsDownloader.Logging;
using Microsoft.Extensions.Logging;

namespace AzResourceDetailsDownloader.Tests;

public class PrefixedLoggerTests
{
    // Minimal fake, not a mocking framework — just enough to capture what the wrapped inner logger
    // was actually called with, since that's the entire contract PrefixedLogger exists to provide.
    private sealed class FakeInnerLogger : ILogger
    {
        public string? LastFormattedMessage { get; private set; }
        public LogLevel? IsEnabledCalledWith { get; private set; }
        public object? BeginScopeCalledWith { get; private set; }

        public IDisposable? BeginScope<TState>(TState state) where TState : notnull
        {
            BeginScopeCalledWith = state;
            return null;
        }

        public bool IsEnabled(LogLevel logLevel)
        {
            IsEnabledCalledWith = logLevel;
            return true;
        }

        public void Log<TState>(LogLevel logLevel, EventId eventId, TState state, Exception? exception, Func<TState, Exception?, string> formatter)
        {
            LastFormattedMessage = formatter(state, exception);
        }
    }

    [Fact]
    public void Log_PrependsThePrefixToTheFormattedMessage()
    {
        var inner = new FakeInnerLogger();
        var logger = new PrefixedLogger(inner, "[Microsoft.KeyVault/vaults] ");

        logger.Log(LogLevel.Information, eventId: default, state: "provisioning started", exception: null,
            formatter: (s, _) => s);

        Assert.Equal("[Microsoft.KeyVault/vaults] provisioning started", inner.LastFormattedMessage);
    }

    [Fact]
    public void IsEnabled_DelegatesToTheInnerLogger()
    {
        var inner = new FakeInnerLogger();
        var logger = new PrefixedLogger(inner, "[prefix] ");

        var result = logger.IsEnabled(LogLevel.Warning);

        Assert.True(result);
        Assert.Equal(LogLevel.Warning, inner.IsEnabledCalledWith);
    }

    [Fact]
    public void BeginScope_DelegatesToTheInnerLogger()
    {
        var inner = new FakeInnerLogger();
        var logger = new PrefixedLogger(inner, "[prefix] ");

        logger.BeginScope("some-scope");

        Assert.Equal("some-scope", inner.BeginScopeCalledWith);
    }
}
