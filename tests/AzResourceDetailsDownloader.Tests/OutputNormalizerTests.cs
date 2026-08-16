using AzResourceDetailsDownloader.Capture;
using AzResourceDetailsDownloader.Output;

namespace AzResourceDetailsDownloader.Tests;

public class OutputNormalizerTests
{
    [Fact]
    public void Normalize_ReplacesSubscriptionTenantAndRgName()
    {
        const string subscriptionId = "e78cb18c-eccd-4470-9986-29c3a1a58654";
        const string tenantId = "8b87af7d-8647-4dc7-8df4-5f69a2011bb5";
        const string rgName = "rg-ardl-abcdef0123456789";
        var text = $$"""{"id": "/subscriptions/{{subscriptionId}}/resourceGroups/{{rgName}}", "tenant": "{{tenantId}}"}""";

        var result = OutputNormalizer.Normalize(text, subscriptionId, tenantId, rgName, "Microsoft.Storage/storageAccounts");

        Assert.Contains(OutputNormalizer.PlaceholderSubscriptionId, result);
        Assert.Contains(OutputNormalizer.PlaceholderTenantId, result);
        Assert.DoesNotContain(subscriptionId, result);
        Assert.DoesNotContain(tenantId, result);
        Assert.DoesNotContain(rgName, result);
    }

    [Fact]
    public void Normalize_UsesDistinctPlaceholders_ForSubscriptionAndTenant()
    {
        Assert.NotEqual(OutputNormalizer.PlaceholderSubscriptionId, OutputNormalizer.PlaceholderTenantId);
    }

    [Fact]
    public void Normalize_IsCaseInsensitive()
    {
        const string subscriptionId = "e78cb18c-eccd-4470-9986-29c3a1a58654";
        var text = $"Value: {subscriptionId.ToUpperInvariant()}";

        var result = OutputNormalizer.Normalize(text, subscriptionId, "tenant-id-placeholder", "rg-name", "Microsoft.Storage/storageAccounts");

        Assert.Contains(OutputNormalizer.PlaceholderSubscriptionId, result);
    }

    [Fact]
    public void Normalize_RgNamePlaceholder_IsDeterministicPerArmType()
    {
        const string rgName = "rg-ardl-abcdef0123456789";
        var result = OutputNormalizer.Normalize($"rg={rgName}", "sub", "tenant", rgName, "Microsoft.Storage/storageAccounts");

        var expectedPlaceholder = Provisioning.DeterministicNaming.PlaceholderResourceGroupName("Microsoft.Storage/storageAccounts");
        Assert.Contains(expectedPlaceholder, result);
    }

    [Fact]
    public void Normalize_RedactsUserPrincipalName_WhenProvided()
    {
        // Live-observed leak (2026-08-13, Microsoft.CognitiveServices/accounts and 30+ other types):
        // ARM auto-stamps the signed-in user's real UPN into every resource's
        // systemData.createdBy/lastModifiedBy — uncaught because nothing upstream of this method
        // knew what value to redact until AzCliContext started resolving it.
        const string upn = "jane.doe@example.com";
        var text = $"{{\"systemData\": {{\"createdBy\": \"{upn}\", \"lastModifiedBy\": \"{upn}\"}}}}";

        var result = OutputNormalizer.Normalize(text, "sub", "tenant", "rg", "Microsoft.Storage/storageAccounts", upn);

        Assert.DoesNotContain(upn, result);
        Assert.Contains(OutputNormalizer.PlaceholderUserPrincipalName, result);
    }

    [Fact]
    public void Normalize_LeavesTextUnchanged_WhenUserPrincipalNameIsNull()
    {
        var text = """{"systemData": {"createdBy": "someone@example.org"}}""";

        var result = OutputNormalizer.Normalize(text, "sub-id", "tenant-id", "rg-ardl-abcdef0123456789", "Microsoft.Storage/storageAccounts", userPrincipalName: null);

        Assert.Equal(text, result);
    }

    [Fact]
    public void Normalize_RedactsAdminPrincipalId_WhenProvided()
    {
        // Live-observed leak (2026-08-16, Microsoft.AnalysisServices/servers): the {secret.
        // adminPrincipalId} catalog token resolves to the operator's own real AAD object ID and
        // several catalog entries embed it verbatim in asAdministrators/administration.members —
        // uncaught because nothing upstream of this method knew to redact it, same blind spot as
        // the UPN case above.
        const string adminPrincipalId = "e580c62a-96a8-430f-96a9-33d936178197";
        var text = "{\"properties\": {\"asAdministrators\": {\"members\": [\"" + adminPrincipalId + "\"]}}}";

        var result = OutputNormalizer.Normalize(
            text, "sub", "tenant", "rg", "Microsoft.AnalysisServices/servers", adminPrincipalId: adminPrincipalId);

        Assert.DoesNotContain(adminPrincipalId, result);
        Assert.Contains(OutputNormalizer.PlaceholderAdminPrincipalId, result);
    }

    [Fact]
    public void Normalize_RedactsResolvedSecretValues_WhenProvided()
    {
        // A real Storage Account key resolved via {prereq.*.key} (see ResourceTypePipeline/
        // RawArmClient.ListStorageAccountPrimaryKeyAsync, added 2026-08-16 for HDInsight/clusters)
        // must never land in committed output — same discipline as every other credential/identity
        // value this class redacts, just for an open-ended set of future prerequisite-key sources
        // rather than one named field.
        const string storageKey = "abcd1234RealStorageKeyValue==";
        var text = "{\"properties\": {\"storageaccounts\": [{\"key\": \"" + storageKey + "\"}]}}";

        var result = OutputNormalizer.Normalize(
            text, "sub", "tenant", "rg", "Microsoft.HDInsight/clusters", resolvedSecretValues: [storageKey]);

        Assert.DoesNotContain(storageKey, result);
        Assert.Contains(OutputNormalizer.PlaceholderResolvedSecret, result);
    }

    [Fact]
    public void NormalizePortalFields_RedactsEntraAdminFields_RegardlessOfExactLabel()
    {
        // Live-observed leak (2026-08-13, Microsoft.Synapse/workspaces): "SQL Microsoft Entra admin"
        // surfaced the operator's real personal email. Matched by substring ("Entra admin") rather
        // than an exact label, since other SQL/DB types expose the same concept under a different
        // exact label (e.g. plain "Microsoft Entra admin").
        var fields = new List<PortalField>
        {
            new("SQL Microsoft Entra admin", "live.com#jane.doe@example.com"),
            new("Microsoft Entra admin", "someone@realcompany.com"),
        };

        var result = OutputNormalizer.NormalizePortalFields(fields);

        Assert.All(result, f => Assert.Equal(OutputNormalizer.PlaceholderEntraAdmin, f.Value));
    }

    [Fact]
    public void NormalizePortalFields_RedactsDirectoryAndSubscriptionDisplayNames()
    {
        // Live-observed leak (2026-08-13): a real capture surfaced the actual AAD tenant name under
        // "Directory Name" — the Essentials panel's own GUID fields (Subscription ID, Directory ID)
        // are caught by Normalize()'s substring replacement, but these two display-name fields aren't
        // the ID string, so they need their own label-targeted redaction.
        var fields = new List<PortalField>
        {
            new("Directory Name", "faketenantname"),
            new("Subscription", "My Real Company Subscription"),
            new("Location", "Norway East"),
        };

        var result = OutputNormalizer.NormalizePortalFields(fields);

        Assert.Equal(OutputNormalizer.PlaceholderDirectoryName, result.Single(f => f.Label == "Directory Name").Value);
        Assert.Equal(OutputNormalizer.PlaceholderSubscriptionName, result.Single(f => f.Label == "Subscription").Value);
        Assert.Equal("Norway East", result.Single(f => f.Label == "Location").Value);
    }

    [Fact]
    public void NormalizePortalFields_RedactsSubscriptionNameLabelVariant()
    {
        // Live-observed leak (2026-08-16, Microsoft.AnalysisServices/servers — the "asx-overview-
        // essentials__*" custom layout): this blade type labels the same subscription display-name
        // field "Subscription name", not the "Subscription" label every other captured type used,
        // so the exact-match switch let "Azure subscription 1" through uncaught.
        var fields = new List<PortalField> { new("Subscription name", "Azure subscription 1") };

        var result = OutputNormalizer.NormalizePortalFields(fields);

        Assert.Equal(OutputNormalizer.PlaceholderSubscriptionName, result.Single().Value);
    }
}
