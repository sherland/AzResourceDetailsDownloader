using AzResourceDetailsDownloader.Config;

namespace AzResourceDetailsDownloader.Output;

// Resolves which of Microsoft's official category buckets (config/resource-abbreviations.json) a given
// armType belongs in, for use in the output/{category}/{armType}/ folder structure.
public sealed class CategoryResolver
{
    public const string Uncategorized = "uncategorized";

    private readonly Dictionary<string, AbbreviationEntry> _entryByNamespace;
    private readonly Dictionary<string, string> _categoryByOverrideArmType;

    public CategoryResolver(ResourceAbbreviationsCatalog? catalog, CategoryOverridesCatalog? overrides = null)
    {
        _entryByNamespace = new Dictionary<string, AbbreviationEntry>(StringComparer.OrdinalIgnoreCase);
        if (catalog is not null)
        {
            foreach (var entry in catalog.Entries)
            {
                if (!_entryByNamespace.TryGetValue(entry.ResourceProviderNamespace, out var existing))
                {
                    _entryByNamespace[entry.ResourceProviderNamespace] = entry;
                    continue;
                }

                // Multiple entries can share a namespace. Usually kind-qualified variants (e.g. Cognitive
                // Services) that share the same category — the first one found is fine there. Live-verified two
                // rare exceptions with no kind qualifier at all and genuinely different categories (storage
                // accounts: "Storage account"/Storage vs. "VM storage account"/Compute and web; firewall
                // policies: "Firewall policy"/Networking vs. "Web Application Firewall (WAF) policy"/Security).
                // For those, prefer whichever entry has the shorter, more generic Resource name — a simple,
                // deterministic tie-break based on the actual pattern found, not a guess at Microsoft's intent.
                if (existing.Category != entry.Category && entry.Resource.Length < existing.Resource.Length)
                {
                    _entryByNamespace[entry.ResourceProviderNamespace] = entry;
                }
            }
        }

        _categoryByOverrideArmType = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        if (overrides is not null)
        {
            foreach (var o in overrides.Overrides)
            {
                _categoryByOverrideArmType[o.ArmType] = o.Category;
            }
        }
    }

    public string ResolveCategory(string armType)
    {
        var candidate = armType;
        while (true)
        {
            if (_entryByNamespace.TryGetValue(candidate, out var entry))
            {
                return entry.Category;
            }

            var lastSlash = candidate.LastIndexOf('/');
            var firstSlash = candidate.IndexOf('/');
            if (lastSlash < 0 || firstSlash == lastSlash)
            {
                // Down to just "Provider/Type" (or no slash at all) with no match — stripping further would
                // remove the type name entirely, so there's nothing more meaningful to look up.
                break;
            }

            candidate = candidate[..lastSlash];
        }

        // Microsoft's table doesn't cover every armType (even via parent-fallback). Before giving up, check the
        // hand-curated config/category-overrides.json — a fallback layer for exactly these gaps, never touched
        // by fetch-resource-abbreviations.ps1 so it survives re-fetches. Exact match only: overrides are
        // curated per-armType, so there's no parent-walk to do.
        if (_categoryByOverrideArmType.TryGetValue(armType, out var overrideCategory))
        {
            return overrideCategory;
        }

        return Uncategorized;
    }
}
