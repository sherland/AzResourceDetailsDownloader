using System.Text.RegularExpressions;

namespace AzResourceDetailsDownloader.Output;

// Same purpose as ArmTypeKey, but for category names (e.g. "AI + machine learning", "DevOps") which contain
// spaces and punctuation ArmTypeKey doesn't need to handle since armType strings are already slash/dot-only.
public static partial class CategoryKey
{
    public static string From(string category) =>
        NonAlphanumericRun().Replace(category.ToLowerInvariant(), "_").Trim('_');

    [GeneratedRegex("[^a-z0-9]+")]
    private static partial Regex NonAlphanumericRun();
}
