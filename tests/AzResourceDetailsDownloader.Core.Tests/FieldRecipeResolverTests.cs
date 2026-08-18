using System.Text.Json;
using AzResourceDetailsDownloader.Options;
using AzResourceDetailsDownloader.Templating;

namespace AzResourceDetailsDownloader.Tests;

public class FieldRecipeResolverTests
{
    // Live-run regression: "Soft-delete" = "Enabled" on Key Vault only coincidentally matches
    // properties.publicNetworkAccess ("Enabled") by raw substring — a blind value-only matcher
    // picks that unrelated property. The real backing property is enableSoftDelete (a bool, true).
    // Catches the disambiguation logic (value match + label/property-name similarity) regressing
    // back to picking whatever value-matching leaf comes first.
    [Fact]
    public void Resolve_PicksNameSimilarProperty_OverCoincidentalValueMatch()
    {
        var root = LoadCapturedResource("security", "microsoft_keyvault_vaults");

        var recipe = FieldRecipeResolver.Resolve("Soft-delete", "Enabled", root);

        Assert.Equal(FieldRecipeKind.Direct, recipe.Kind);
        Assert.Equal("model.props.enablesoftdelete", recipe.Target);
    }

    [Fact]
    public void Resolve_PurgeProtection_PicksOwnProperty_NotUnrelatedEnabledValue()
    {
        var root = LoadCapturedResource("security", "microsoft_keyvault_vaults");

        var recipe = FieldRecipeResolver.Resolve("Purge protection", "Enabled", root);

        Assert.Equal(FieldRecipeKind.Direct, recipe.Kind);
        Assert.Equal("model.props.enablepurgeprotection", recipe.Target);
    }

    // Live-run regression: Key Vault's raw sku is {family:"A", name:"standard"} (no "tier"), so the
    // computed sku_label is "standard" — but the portal capitalizes it ("Standard"). Same value,
    // different casing: a real finding, not a false positive, so it must NOT be silently reported
    // as a verified exact match.
    [Fact]
    public void Resolve_SkuLabel_FlagsCasingMismatch_ForKeyVault()
    {
        var root = LoadCapturedResource("security", "microsoft_keyvault_vaults");

        var recipe = FieldRecipeResolver.Resolve("Sku (Pricing tier)", "Standard", root);

        Assert.Equal(FieldRecipeKind.ShortcutCasingMismatch, recipe.Kind);
        Assert.Equal("model.sku_label", recipe.Target);
    }

    // Live-run regression: Container Registry's sku {name:"Basic", tier:"Basic"} produces sku_label
    // "Basic" (name==tier collapses to just the name) which matches the portal's "Pricing plan"
    // exactly — the one case in the corpus where the SKU shortcut should be trusted outright.
    [Fact]
    public void Resolve_SkuLabel_VerifiesExactly_ForContainerRegistry()
    {
        var root = LoadCapturedResource("containers", "microsoft_containerregistry_registries");

        var recipe = FieldRecipeResolver.Resolve("Pricing plan", "Basic", root);

        Assert.Equal(FieldRecipeKind.ShortcutVerified, recipe.Kind);
        Assert.Equal("model.sku_label", recipe.Target);
    }

    // Container Registry's "Soft delete (Preview)" is a 3-levels-nested boolean
    // (properties.policies.softDeletePolicy.status) — regression guard for the generic resolver's
    // tree walk actually reaching nested objects, not just top-level properties.
    [Fact]
    public void Resolve_FindsDeeplyNestedProperty()
    {
        var root = LoadCapturedResource("containers", "microsoft_containerregistry_registries");

        var recipe = FieldRecipeResolver.Resolve("Soft delete (Preview)", "Disabled", root);

        Assert.Equal(FieldRecipeKind.Direct, recipe.Kind);
        Assert.Equal("model.props.policies.softdeletepolicy.status", recipe.Target);
    }

    // A label known to be composite/vocabulary (see PortalFieldKnowledge.NonTraceableLabels) must
    // stay Unresolved with a hint, never silently accepted just because the value happens to
    // appear somewhere in the document.
    [Fact]
    public void Resolve_KnownCompositeLabel_IsUnresolvedWithHint()
    {
        var root = LoadCapturedResource("security", "microsoft_keyvault_vaults");

        var recipe = FieldRecipeResolver.Resolve("Operating system", "Linux", root);

        Assert.Equal(FieldRecipeKind.Unresolved, recipe.Kind);
        Assert.False(string.IsNullOrWhiteSpace(recipe.Notes));
    }

    // A value that's only traceable outside properties.*/kind/name/id/location (e.g. systemData,
    // identity) is real data but not reachable from a template — must be reported as
    // NotAddressable with null Target, never as a usable model.props.* path.
    [Fact]
    public void Resolve_ValueOnlyInSystemData_IsNotAddressable()
    {
        using var doc = JsonDocument.Parse("""
            {
              "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Test/things/thing1",
              "name": "thing1",
              "type": "Microsoft.Test/things",
              "location": "norwayeast",
              "systemData": { "createdBy": "unique-marker-value-123" },
              "properties": { "unrelated": "something else" }
            }
            """);

        var recipe = FieldRecipeResolver.Resolve("Created By", "unique-marker-value-123", doc.RootElement);

        Assert.Equal(FieldRecipeKind.NotAddressable, recipe.Kind);
        Assert.Null(recipe.Target);
    }

    // A value that matches nowhere in the document at all must be Unresolved, not silently pass.
    [Fact]
    public void Resolve_ValueNotFoundAnywhere_IsUnresolved()
    {
        using var doc = JsonDocument.Parse("""
            {
              "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Test/things/thing1",
              "name": "thing1",
              "type": "Microsoft.Test/things",
              "location": "norwayeast",
              "properties": { "unrelated": "something else" }
            }
            """);

        var recipe = FieldRecipeResolver.Resolve("Made Up Label", "value-that-appears-nowhere", doc.RootElement);

        Assert.Equal(FieldRecipeKind.Unresolved, recipe.Kind);
        Assert.Null(recipe.Target);
    }

    // Two equally-plausible candidates (same value, same name-similarity score) must be reported
    // as Ambiguous rather than the resolver silently picking whichever happens to enumerate first.
    [Fact]
    public void Resolve_TiedCandidates_AreReportedAsAmbiguous()
    {
        using var doc = JsonDocument.Parse("""
            {
              "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Test/things/thing1",
              "name": "thing1",
              "type": "Microsoft.Test/things",
              "location": "norwayeast",
              "properties": {
                "items": [
                  { "count": 7 },
                  { "count": 7 }
                ]
              }
            }
            """);

        var recipe = FieldRecipeResolver.Resolve("Count", "7", doc.RootElement);

        Assert.Equal(FieldRecipeKind.Ambiguous, recipe.Kind);
    }

    // Live-run regression: "Forward messages to" = "Disabled" on Service Bus queues previously
    // matched properties.deadLetteringOnMessageExpiration as a "Direct" (fully-trusted) recipe —
    // wrong property, just a coincidental value match propped up by "messages" fuzzy-stemming
    // against "message". Must come back as a low-confidence NeedsReview instead, never Direct.
    [Fact]
    public void Resolve_ForwardMessagesTo_IsNotConfidentlyMatched_ToUnrelatedDeadLetterProperty()
    {
        var root = LoadCapturedResource("integration", "microsoft_servicebus_namespaces_queues");

        var recipe = FieldRecipeResolver.Resolve("Forward messages to", "Disabled", root);

        Assert.NotEqual(FieldRecipeKind.Direct, recipe.Kind);
    }

    // Live-run regression: "Managed virtual network" = "No" on Synapse workspaces previously
    // matched properties.defaultDataLakeStorage.createManagedPrivateEndpoint as "Direct" — wrong
    // property, just the generic word "managed" coincidentally appearing in both. Must come back as
    // NeedsReview, never a confidently-trusted Direct match.
    [Fact]
    public void Resolve_ManagedVirtualNetwork_IsNotConfidentlyMatched_ToUnrelatedProperty()
    {
        var root = LoadCapturedResource("analytics_and_iot", "microsoft_synapse_workspaces");

        var recipe = FieldRecipeResolver.Resolve("Managed virtual network", "No", root);

        Assert.NotEqual(FieldRecipeKind.Direct, recipe.Kind);
    }

    // Key Vault's raw "location" is the usual lowercase ARM code ("norwayeast") — verified via
    // config/azure-locations.json, not just trusted with a caveat like before this lookup existed.
    [Fact]
    public void Resolve_Location_VerifiesLowercaseArmCode_ViaRegionLookup()
    {
        var root = LoadCapturedResource("security", "microsoft_keyvault_vaults");

        var recipe = FieldRecipeResolver.Resolve("Location", "Norway East", root);

        Assert.Equal(FieldRecipeKind.ShortcutVerified, recipe.Kind);
        Assert.Equal("model.location", recipe.Target);
    }

    // Live-run regression: Notification Hubs' raw "location" is already display text ("Norway
    // East"), not the lowercase code most types return. Must verify directly instead of failing to
    // find "Norway East" in a table keyed by lowercase codes.
    [Fact]
    public void Resolve_Location_VerifiesAlreadyDisplayFormRegion()
    {
        var root = LoadCapturedResource("compute_and_web", "microsoft_notificationhubs_namespaces");

        var recipe = FieldRecipeResolver.Resolve("Location", "Norway East", root);

        Assert.Equal(FieldRecipeKind.ShortcutVerified, recipe.Kind);
    }

    // Live-run regression: Azure Maps' raw "location" is "global" (lowercase), portal shows
    // "Global" — a non-regional value with no entry in the physical-regions lookup either way, so
    // this must resolve via the casing-insensitive fallback, not fall through to "unverified".
    [Fact]
    public void Resolve_Location_HandlesGlobalCasingDifference()
    {
        var root = LoadCapturedResource("developer_tools", "microsoft_maps_accounts");

        var recipe = FieldRecipeResolver.Resolve("Location", "Global", root);

        Assert.Equal(FieldRecipeKind.ShortcutCasingMismatch, recipe.Kind);
    }

    // Resource group isn't its own field in a raw ARM GET response — only embedded in "id" — so
    // this locks in the extraction-and-compare logic actually verifying it instead of blindly
    // trusting model.resource_group like the pre-fix behavior did.
    [Fact]
    public void Resolve_ResourceGroup_VerifiesAgainstIdExtraction()
    {
        var root = LoadCapturedResource("security", "microsoft_keyvault_vaults");
        var expectedRg = root.GetProperty("id").GetString()!.Split('/')[4];

        var recipe = FieldRecipeResolver.Resolve("Resource group", expectedRg, root);

        Assert.Equal(FieldRecipeKind.ShortcutVerified, recipe.Kind);
        Assert.Equal("model.resource_group", recipe.Target);
    }

    // A resolvable field can still be live/transient state — IsLiveState is orthogonal to Kind, so
    // a resolved "Status" must still come back flagged, not just an unresolved one.
    [Fact]
    public void Resolve_LiveStateLabel_IsFlagged_EvenWhenResolved()
    {
        var root = LoadCapturedResource("containers", "microsoft_containerregistry_registries");

        var recipe = FieldRecipeResolver.Resolve("Provisioning state", "Succeeded", root);

        Assert.True(recipe.IsLiveState);
        // Live-run regression: this used to be forced to Unresolved regardless of any real match —
        // "Provisioning state" was never added to AttemptDespiteNonTraceableHint the way "Status"
        // was, even though Container Registry's is a plain passthrough of provisioningState. Caught
        // by generating a real template and finding an unnecessary TODO row, not by re-auditing the
        // label tables.
        Assert.Equal(FieldRecipeKind.Direct, recipe.Kind);
        Assert.Equal("model.props.provisioningstate", recipe.Target);
    }

    // The VM's power state isn't in the capture body at all — Unresolved — but it's still live
    // state, and a renderer needs that flag regardless of whether a value could be found, so it
    // can show a "see the portal" placeholder instead of silently dropping the row.
    [Fact]
    public void Resolve_LiveStateLabel_IsFlagged_EvenWhenUnresolved()
    {
        var root = LoadCapturedResource("compute_and_web", "microsoft_compute_virtualmachines");

        var recipe = FieldRecipeResolver.Resolve("Status", "Running", root);

        Assert.True(recipe.IsLiveState);
        Assert.Equal(FieldRecipeKind.Unresolved, recipe.Kind);
    }

    // A stable configuration value (SKU) must never be flagged as live state, even though it's
    // resolved via the same code paths.
    [Fact]
    public void Resolve_StableConfigLabel_IsNotFlaggedAsLiveState()
    {
        var root = LoadCapturedResource("security", "microsoft_keyvault_vaults");

        var recipe = FieldRecipeResolver.Resolve("Vault URI", "https://kvrq6-2c9f.vault.azure.net/", root);

        Assert.False(recipe.IsLiveState);
    }

    // "Different API surface" was too broad a generalization — Application Insights genuinely
    // stores these as plain resource properties, unlike (say) Storage Account keys, which really do
    // need a separate listKeys call. Same shape of gap as Status/Provisioning state: found by
    // actually generating a template and seeing an unnecessary TODO row, not by re-auditing labels.
    [Fact]
    public void Resolve_InstrumentationKey_ResolvesDirectly_ForApplicationInsights()
    {
        var root = LoadCapturedResource("management_and_governance", "microsoft_insights_components");
        // Read live rather than hardcode: Application Insights generates a fresh random GUID on
        // every capture, so a hardcoded value here breaks on every recapture of this type even
        // though the resolver logic under test hasn't changed — live-caught 2026-08-16.
        var instrumentationKey = root.GetProperty("properties").GetProperty("InstrumentationKey").GetString()!;

        var recipe = FieldRecipeResolver.Resolve("Instrumentation key", instrumentationKey, root);

        Assert.Equal(FieldRecipeKind.Direct, recipe.Kind);
        Assert.Equal("model.props.instrumentationkey", recipe.Target);
    }

    // Live-run regression: Storage Accounts' "Created" previously tied between properties.creationTime
    // and properties.keyCreationTime.key1 (the account and its access key are created within
    // milliseconds of each other, so both match the same displayed second) and picked the WRONG one
    // arbitrarily — "created" scored 0 name-similarity against both "creationTime" and
    // "keyCreationTime" under the old StartsWith-only matching, since "created"/"creation" diverge at
    // their 6th letter despite sharing a root. Must now clearly prefer the actual creation-time
    // property, not the access key's.
    [Fact]
    public void Resolve_Created_PrefersCreationTimeOverKeyCreationTime_ForStorageAccount()
    {
        var root = LoadCapturedResource("storage", "microsoft_storage_storageaccounts");

        var recipe = FieldRecipeResolver.Resolve("Created", "14.8.2026, 12:28:04", root);

        Assert.Equal(FieldRecipeKind.Timestamp, recipe.Kind);
        Assert.Equal("model.props.creationtime", recipe.Target);
    }

    // Live-run regression: CDN profiles' "Origin response timeout" = "30 Seconds" previously stayed
    // Unresolved even though properties.originResponseTimeoutSeconds = 30 backs it exactly — plain
    // normalized-string equality can't bridge a JSON number against a value with a trailing unit
    // word. Must now resolve Direct, with the unit text carried as a LiteralSuffix rather than lost.
    [Fact]
    public void Resolve_OriginResponseTimeout_MatchesNumberDespiteUnitSuffix_ForCdnProfile()
    {
        var root = LoadCapturedResource("networking", "microsoft_cdn_profiles");

        var recipe = FieldRecipeResolver.Resolve("Origin response timeout", "30 Seconds", root);

        Assert.Equal(FieldRecipeKind.Direct, recipe.Kind);
        Assert.Equal("model.props.originresponsetimeoutseconds", recipe.Target);
        Assert.Equal(" Seconds", recipe.LiteralSuffix);
    }

    // Same unit-suffix gap, different unit word ("GiB" instead of "Seconds") — confirms the fix
    // isn't accidentally specific to one literal suffix string.
    [Fact]
    public void Resolve_DiskSize_MatchesNumberDespiteGiBSuffix_ForComputeDisk()
    {
        var root = LoadCapturedResource("compute_and_web", "microsoft_compute_disks");

        var recipe = FieldRecipeResolver.Resolve("Disk size", "4 GiB", root);

        Assert.Equal(FieldRecipeKind.Direct, recipe.Kind);
        Assert.Equal("model.props.disksizegb", recipe.Target);
        Assert.Equal(" GiB", recipe.LiteralSuffix);
    }

    // A JSON number leaf whose value merely starts with the same digits as an unrelated portal
    // string must NOT be treated as a unit-suffix match — the leading-number comparison requires
    // the whole numeric prefix to parse to an equal value, not just a shared first character.
    [Fact]
    public void Resolve_NumericUnitSuffixMatch_RequiresExactLeadingNumber_NotJustAPrefixDigit()
    {
        using var doc = JsonDocument.Parse("""
            {
              "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Test/things/thing1",
              "name": "thing1",
              "type": "Microsoft.Test/things",
              "location": "norwayeast",
              "properties": { "widgetCount": 3 }
            }
            """);

        var recipe = FieldRecipeResolver.Resolve("Widget count", "30 Seconds", doc.RootElement);

        Assert.Equal(FieldRecipeKind.Unresolved, recipe.Kind);
    }

    // Live-run regression: Search Services' "Replicas" = "1 (No SLA)" traces to replicaCount:1, but
    // "(No SLA)" is a CONDITIONAL annotation the portal only shows when the count is exactly 1 (see
    // AttemptDespiteNonTraceableHint's comment) — not a constant unit like " GiB"/" Seconds". The
    // numeric-unit-suffix match must reject this trailing text rather than bake it in as if it were
    // always true, which would render "(No SLA)" even for a resource with 3 replicas.
    [Fact]
    public void Resolve_NumericUnitSuffixMatch_RejectsConditionalParentheticalAnnotation_NotAConstantUnit()
    {
        var root = LoadCapturedResource("ai_machine_learning", "microsoft_search_searchservices");

        var recipe = FieldRecipeResolver.Resolve("Replicas", "1 (No SLA)", root);

        Assert.NotEqual(FieldRecipeKind.Direct, recipe.Kind);
    }

    // Live-run regression: SignalR/Web PubSub's "Unit" and EventHub's "Throughput Units" all trace
    // to sku.capacity, which previously had no first-class model field and so was reported
    // NotAddressable even after a genuine value match — sku.capacity must now be reachable as
    // model.sku_capacity.
    [Fact]
    public void Resolve_SkuCapacity_IsAddressable_ForSignalR()
    {
        var root = LoadCapturedResource("developer_tools", "microsoft_signalrservice_signalr");
        var capacity = root.GetProperty("sku").GetProperty("capacity").GetRawText();

        var recipe = FieldRecipeResolver.Resolve("Unit", capacity, root);

        Assert.NotEqual(FieldRecipeKind.NotAddressable, recipe.Kind);
    }

    // Live-run regression: "Name" was blanket-classified as composite/unresolved on the strength of
    // a single observed exception (Portal/dashboards' "{name} (friendly title)"), even though it's
    // a plain, exact passthrough of the resource's own root "name" field on every other captured
    // type — confirmed here on a child/nested resource type (AFD endpoints), where "Name" is a
    // genuine Essentials row distinct from the H1 title.
    [Fact]
    public void Resolve_Name_ResolvesDirectlyToModelName_ForAfdEndpoint()
    {
        var root = LoadCapturedResource("networking", "microsoft_cdn_profiles_afdendpoints");
        var name = root.GetProperty("name").GetString()!;

        var recipe = FieldRecipeResolver.Resolve("Name", name, root);

        Assert.Equal(FieldRecipeKind.ShortcutVerified, recipe.Kind);
        Assert.Equal("model.name", recipe.Target);
    }

    // The one genuine exception found: Portal/dashboards renders "{name} ({friendly title})" — a
    // real composite this capture has no traceable source for. Must stay NeedsReview (still
    // pointing at model.name as the right lead), never a confidently-trusted exact match.
    [Fact]
    public void Resolve_Name_IsNeedsReview_WhenPortalAppendsAFriendlyTitle_ForDashboards()
    {
        var root = LoadCapturedResource("management_and_governance", "microsoft_portal_dashboards");
        var rawName = root.GetProperty("name").GetString()!;

        var recipe = FieldRecipeResolver.Resolve("Name", $"{rawName} (ARDL Dashboard)", root);

        Assert.Equal(FieldRecipeKind.NeedsReview, recipe.Kind);
        Assert.Equal("model.name", recipe.Target);
    }

    private static JsonElement LoadCapturedResource(string category, string armTypeFolder)
    {
        var repoRoot = RepoPaths.ResolveRepoRoot();
        var dataJsonPath = Path.Combine(repoRoot, "output", category, armTypeFolder, "data.json");
        using var doc = JsonDocument.Parse(File.ReadAllText(dataJsonPath));
        return doc.RootElement.Clone();
    }
}
