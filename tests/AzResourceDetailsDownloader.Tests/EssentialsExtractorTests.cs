using AzResourceDetailsDownloader.Capture;

namespace AzResourceDetailsDownloader.Tests;

public class EssentialsExtractorTests
{
    // Real (trimmed) field-object-literal fragments from builder sources this project actually
    // dumped live 2026-08-14 (Storage Accounts) and 2026-08-15 (Compute/disks) — not synthetic
    // examples, so a regression here means the heuristic stopped matching the real portal shape,
    // not just a made-up one.
    [Fact]
    public void ExtractCandidateHelperNames_FindsRealHelperCallsFromStorageAccountBuilder()
    {
        const string builderSourceFragment =
            "s.push({label:ue.React_Overview_Essentials.replication," +
            "value:Ve(n?.sku?.name,n?.kind===te.b8.Storage)||ue.StorageResources.noContent," +
            "column:Me.FieldColumn.Right,shimmer:!0,isDataLoaded:!!n}," +
            "{label:...,value:Le(n?.kind,n?.id),column:Me.FieldColumn.Right}), " +
            "s.push({label:ue.React_Overview_Essentials.provisioningState,value:je(e?.provisioningState),...})";

        var names = EssentialsExtractor.ExtractCandidateHelperNames(builderSourceFragment);

        Assert.Equal(["Le", "Ve", "je"], names);
    }

    [Fact]
    public void ExtractCandidateHelperNames_FindsRealHelperCallsFromDiskBuilder()
    {
        const string builderSourceFragment =
            "{...i,label:yt.ManagedDisks_DiskSku.label,value:e.disk?.sku?.name?Hs(e.disk.sku.name):bt.ComputeResources.noContent}," +
            "r&&n.push({...i,label:yt.ManagedDisks_DiskSize.securityType,value:st(e.disk?.properties?.securityProfile?.securityType)})";

        var names = EssentialsExtractor.ExtractCandidateHelperNames(builderSourceFragment);

        Assert.Equal(["Hs", "st"], names);
    }

    [Fact]
    public void ExtractCandidateHelperNames_IgnoresPlainPropertyAccessNotFollowedByCall()
    {
        // A plain `value:e?.foo` passthrough (Disks' "Managed by"/"Operating system" shape) has no
        // parenthesis immediately after an identifier — must not be mistaken for a helper call.
        const string builderSourceFragment =
            "{...i,label:bt.DiskDetails.operatingSystem,value:e.disk?.properties?.osType??bt.ComputeResources.noContent}";

        var names = EssentialsExtractor.ExtractCandidateHelperNames(builderSourceFragment);

        Assert.Empty(names);
    }

    [Fact]
    public void ExtractCandidateHelperNames_IgnoresJsxHelperCallsWithLeadingParenZero()
    {
        // `(0,t.jsx)(...)` — React's own createElement-shorthand call convention, everywhere in
        // every builder source this project has dumped — must never be mistaken for a field
        // transform helper. Guarded against by requiring the match to sit directly after `value:`
        // with a bare identifier, which `(0,t.jsx)` never is (it starts with `(`).
        const string builderSourceFragment =
            "{label:s.Foo,value:(0,t.jsx)(Ne.BladeLink,{bladeReference:h,children:s.Bar})}";

        var names = EssentialsExtractor.ExtractCandidateHelperNames(builderSourceFragment);

        Assert.Empty(names);
    }

    [Fact]
    public void ExtractCandidateHelperNames_DedupesRepeatedCallsToTheSameHelper()
    {
        const string builderSourceFragment =
            "{value:w(e?.properties?.powerState?.code)},{value:w(e?.properties?.other)}";

        var names = EssentialsExtractor.ExtractCandidateHelperNames(builderSourceFragment);

        Assert.Equal(["w"], names);
    }
}
