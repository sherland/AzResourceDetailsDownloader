using System.Diagnostics.CodeAnalysis;

namespace AzResourceDetailsDownloader.Config;

// Plain data, no behavior — excluded from coverage rather than left dragging the Core % down for
// no reason; see ParsedArgsTests/OutputWriterTests/etc. for where this project's effort actually
// goes instead. Only classes with zero logic get this attribute — see the commit that added it for
// the classes deliberately NOT excluded despite looking similarly small.
[ExcludeFromCodeCoverage]
public sealed class NameRules
{
    public required string Charset { get; init; }
    public required int MaxLength { get; init; }
}
