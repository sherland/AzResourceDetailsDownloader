using System.Runtime.CompilerServices;

// Lets the test project verify internal-only sharing details (e.g. EssentialsExtractor's
// FindBuilderFunctionJsFragment, deliberately internal — not public — because it's an
// assembly-internal sharing mechanism with FieldBindingInvestigator, not a pure function meant for
// public consumption) without widening those members' visibility just to make them testable.
[assembly: InternalsVisibleTo("AzResourceDetailsDownloader.Infrastructure.Tests")]
