using AzResourceDetailsDownloader.Cli;
using Microsoft.Extensions.Logging;

namespace AzResourceDetailsDownloader.Tests;

public class LogRingBufferTests
{
    [Fact]
    public void Snapshot_ReturnsLinesInInsertionOrder()
    {
        var buffer = new LogRingBuffer(capacity: 10);

        buffer.Add("first");
        buffer.Add("second");
        buffer.Add("third");

        Assert.Equal(["first", "second", "third"], buffer.Snapshot());
    }

    [Fact]
    public void Add_BeyondCapacity_DropsOldestLines()
    {
        var buffer = new LogRingBuffer(capacity: 3);

        buffer.Add("a");
        buffer.Add("b");
        buffer.Add("c");
        buffer.Add("d");

        Assert.Equal(["b", "c", "d"], buffer.Snapshot());
    }

    [Fact]
    public void Snapshot_Empty_ReturnsEmptyList()
    {
        var buffer = new LogRingBuffer();

        Assert.Empty(buffer.Snapshot());
    }
}

public class RingBufferLoggerProviderTests
{
    [Fact]
    public void Log_Information_AppendsFormattedLineToBuffer()
    {
        var buffer = new LogRingBuffer();
        var logger = new RingBufferLoggerProvider(buffer).CreateLogger("test");

        logger.LogInformation("hello {Name}", "world");

        Assert.Equal(["hello world"], buffer.Snapshot());
    }

    [Fact]
    public void Log_BelowInformationLevel_IsFiltered()
    {
        var buffer = new LogRingBuffer();
        var logger = new RingBufferLoggerProvider(buffer).CreateLogger("test");

        logger.LogDebug("should not appear");

        Assert.Empty(buffer.Snapshot());
    }

    [Fact]
    public void Log_WithException_AppendsExceptionMessageToo()
    {
        var buffer = new LogRingBuffer();
        var logger = new RingBufferLoggerProvider(buffer).CreateLogger("test");

        logger.LogWarning(new InvalidOperationException("boom"), "extraction failed");

        var line = Assert.Single(buffer.Snapshot());
        Assert.Contains("extraction failed", line);
        Assert.Contains("boom", line);
    }

    [Fact]
    public void BeginScope_ReturnsNull()
    {
        var logger = new RingBufferLoggerProvider(new LogRingBuffer()).CreateLogger("test");

        Assert.Null(logger.BeginScope("scope"));
    }
}
