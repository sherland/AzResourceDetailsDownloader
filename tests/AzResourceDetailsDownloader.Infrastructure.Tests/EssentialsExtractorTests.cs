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

    [Fact]
    public void Finalize_DropsChromeLabels()
    {
        // "Getting started"/"Manage keys" are real ChromeLabels entries — navigation/action links,
        // never resource data — that render inside an essentials item just like real fields.
        var fields = new List<PortalField>
        {
            new("Getting started", "https://aka.ms/asrs/faq"),
            new("Manage keys", "Click here to manage keys"),
            new("Resource group", "rg-example"),
        };

        var result = EssentialsExtractor.Finalize(fields);

        Assert.Equal([new PortalField("Resource group", "rg-example")], result);
    }

    [Fact]
    public void Finalize_DropsChromeValues_ButKeepsTheLabelWhenItHasRealData()
    {
        // Unlike ChromeLabels, "Tags"/"Add tags" is a legitimate field whose *value* is empty-state
        // portal chrome only on a freshly-provisioned resource — filtered by value, not by label, so
        // a differently-populated capture of the same label still comes through.
        var freshResource = new List<PortalField> { new("Tags", "Add tags") };
        var populatedResource = new List<PortalField> { new("Tags", "env:prod") };

        Assert.Empty(EssentialsExtractor.Finalize(freshResource));
        Assert.Equal(populatedResource, EssentialsExtractor.Finalize(populatedResource));
    }

    [Fact]
    public void Finalize_DedupesByLabel_KeepsFirstOccurrenceCaseInsensitively()
    {
        // The portal can render an item twice during certain transitions (e.g. move-target pickers).
        var fields = new List<PortalField>
        {
            new("Location", "norwayeast"),
            new("LOCATION", "duplicate-should-be-dropped"),
        };

        var result = EssentialsExtractor.Finalize(fields);

        Assert.Equal([new PortalField("Location", "norwayeast")], result);
    }

    [Fact]
    public void Finalize_OrdinaryFields_PassThroughUnchanged()
    {
        var fields = new List<PortalField>
        {
            new("Resource group", "rg-example"),
            new("Location", "norwayeast"),
            new("Subscription", "Contoso Subscription"),
        };

        var result = EssentialsExtractor.Finalize(fields);

        Assert.Equal(fields, result);
    }
}
