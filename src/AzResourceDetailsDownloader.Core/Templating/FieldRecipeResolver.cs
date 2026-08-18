using System.Globalization;
using System.Text.Json;
using System.Text.RegularExpressions;
using AzResourceDetails.Templating;

namespace AzResourceDetailsDownloader.Templating;

public enum FieldRecipeKind
{
    Shortcut,
    ShortcutVerified,
    ShortcutCasingMismatch,
    ShortcutMismatch,
    Context,
    Timestamp,
    NotAddressable,
    TimestampUnresolved,
    Boolean,
    Direct,
    NeedsReview,
    Ambiguous,
    Unresolved,
}

// IsLiveState marks a label as PortalFieldKnowledge.LiveStateLabels does — a currently-observed
// condition rather than a durable setting — independent of Kind/Target/Confidence entirely. A
// renderer should still emit this field's row (dropping it breaks portal-layout parity), but treat
// the value as a "true as of the last capture" snapshot rather than a current fact: e.g. append a
// captured-at caveat, or — when Kind is Unresolved/NotAddressable, meaning there's no captured
// value to show at all (VM power state isn't in the capture body) — render an explicit
// "see the Azure Portal for current status" placeholder instead of silently omitting the row.
// LiteralSuffix carries trailing unit text the portal appends to a raw JSON number that the
// resolved target itself doesn't include (e.g. " GiB", " Seconds") — see ResolveGeneric's
// numeric-unit-suffix matching. Only ever set on a Direct recipe; TemplateGenerator appends it
// after the Scriban expression so the rendered row still reproduces the portal's exact text.
public sealed record FieldRecipe(FieldRecipeKind Kind, double Confidence, string? Target, string Notes, bool IsLiveState = false, string? LiteralSuffix = null);

// Resolves a captured portal Essentials label/value pair down to a "recipe" describing how a
// future template generator could reproduce it: a direct model.props.* path, a known transform
// (timestamp/boolean), a first-class model shortcut, or an explicit "can't be done mechanically"
// verdict with a reason. Combines two independent signals — does the value match, and does the
// property name resemble the label — because value-only matching produces real false positives
// (see NeedsReview below): a short common word like "Enabled" coincidentally equals some unrelated
// property's value more often than you'd expect across a whole ARM properties bag.
public static class FieldRecipeResolver
{
    // Deliberately does NOT include "Type" — its portal value is sometimes a friendly composite
    // string (e.g. Data Factory shows "Data factory (V2)", not the raw ARM type
    // "Microsoft.DataFactory/factories") rather than a literal passthrough, so it stays classified
    // via NonTraceableLabels/UnresolvedLabelHints instead of being short-circuited here.
    private static readonly string[] SkuLikeTokens = ["sku", "pricing"];

    // NonTraceableLabels blanket-skips these for the consistency test's purposes (a label genuinely
    // can't be verified for every type it appears on), but that doesn't mean NO type resolves it —
    // "Status" turned out to be three different problems wearing one label: Container Registry's
    // "Status" is a plain passthrough of provisioningState, Redis's is a composite (provisioningState
    // translated PLUS a SKU-size lookup appended), and the VM's isn't captured at all (power state
    // lives behind a separate API call). Rather than accept the label-level generalization, let these
    // fall through to the generic resolver per (ArmType, label) and see what's actually there —
    // ResolveGeneric harmlessly returns Unresolved (with the fallback hint reattached, see Resolve)
    // when nothing's found, so trying costs nothing.
    private static readonly HashSet<string> AttemptDespiteNonTraceableHint = new(StringComparer.OrdinalIgnoreCase)
    {
        "Status", "Managed", "Forward messages to", "Dead lettering", "Automatic failover enabled",
        "Non-TLS access", "Autoscale", "Availability zones", "Availability zone",
        "Public network access", "Managed virtual network", "Auto-inflate throughput units",
        // Missed in the original "Status" investigation despite being found live: Container
        // Registry's "Provisioning state" is a plain passthrough of properties.provisioningState —
        // caught by actually generating a template and finding it fall back to a TODO row it
        // shouldn't have needed, not by re-auditing the label list.
        "Provisioning state",
        // The "different API surface" bucket had the same problem: Application Insights stores its
        // "Instrumentation key"/"Connection string" as plain resource properties (unlike, say,
        // Storage Account keys, which genuinely do require a separate listKeys call), and SSH
        // Public Keys' "Public key" is a direct properties.publicKey passthrough. Attempting these
        // costs nothing where the original classification was actually right (URL, Account URI,
        // Queue/Topic URL, Logs workspace, Metrics ingestion endpoint, Origin response timeout,
        // Ports all correctly stay Unresolved) — "Endpoint" lands on a genuinely mixed
        // Ambiguous/NeedsReview/Unresolved verdict per type, which is more honest than a blanket
        // skip either way.
        "Endpoint", "URL", "Account URI", "Queue URL", "Topic URL", "Instrumentation key",
        "Connection string", "Logs workspace", "Metrics ingestion endpoint", "Origin response timeout",
        "Public key", "Ports",

        // Confirmed by reading the live Azure Portal's own field-builder source via a React fiber
        // walk (2026-08-14 pilot — see EssentialsExtractor.DumpFiberBuilderSourceAsync and AGENT.md),
        // not by guessing: Compute/disks' "Operating system" is a direct, untransformed
        // `properties.osType` passthrough (it only ever *looked* composite because this tool's own
        // disk captures are always unattached data disks with osType null, rendering as "-"); "Disk
        // size" is the same shape on both disks (`properties.diskSizeGB`) and Mongo vCore clusters
        // (`properties.storage.sizeGb`) — a plain number plus a " GiB" unit suffix, not a real
        // composite; Search Services' "Replicas" is `properties.replicaCount` wrapped in a
        // count-formatter (adds "(No SLA)" only when the count is 1). Attempting these costs nothing
        // where a type's value happens to be empty/placeholder (falls through to Unresolved exactly
        // as before) and gets a real match where it isn't.
        "Operating system", "Disk size", "Replicas",

        // Live-found (2026-08-18), once the numeric-unit-suffix and sku.capacity gaps above were
        // fixed generically in ResolveGeneric/AddressableTarget: Compute/snapshots' "Size" is the
        // exact same diskSizeGB-plus-"GiB" shape as disks' "Disk size" (VM/VMSS's own "Size" values
        // are genuinely composite friendly SKU text and correctly stay Unresolved — the blanket
        // attempt costs them nothing); EventHub's "Throughput Units" and Purview's "Platform size"
        // both trace to sku.capacity, same as SignalR/WebPubSub's "Unit" already did before this
        // list needed touching for them. All four were previously misclassified with the flatly
        // wrong "composite/derived — no single backing property" hint despite a real backing
        // property existing — attempting now at worst downgrades that to an honest NeedsReview.
        "Size", "Throughput Units", "Platform size",
    };

    public static FieldRecipe Resolve(string label, string value, JsonElement root) =>
        Resolve(label, value, root, armType: "");

    // armType-aware overload — needed only for the small number of labels (currently just "Pricing
    // tier" on AppConfiguration/configurationStores) that are shared, with genuinely different
    // meanings/formats, across enough other resource types that a global label-based dispatch (the
    // pattern every other shortcut in this file uses) would be wrong for all of them. Defaults to ""
    // via the overload above so every existing caller/test that doesn't need type-scoping is
    // unaffected — "" never matches a real armType, so type-scoped branches just fall through to the
    // ordinary label-based resolution.
    public static FieldRecipe Resolve(string label, string value, JsonElement root, string armType)
    {
        var recipe = ResolveCore(label, value, root, armType);
        return recipe with { IsLiveState = PortalFieldKnowledge.LiveStateLabels.Contains(label) };
    }

    private static FieldRecipe ResolveCore(string label, string value, JsonElement root, string armType)
    {
        if (label.Equals("Pricing tier", StringComparison.OrdinalIgnoreCase)
            && armType.Equals("Microsoft.AppConfiguration/configurationStores", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveShortcutOrUnverified(value, PortalFriendlyLabels.AppConfigPricingTierLabel(root),
                "model.appconfig_pricing_tier_label",
                "sku.name isn't in the known free/standard/developer/premium table");
        }
        // AppConfiguration's "Soft-delete" is a pure SKU-tier feature-availability flag — Standard
        // tier always shows Enabled, Free tier always shows N/A — with no backing property at all
        // (confirmed live 2026-08-14, the first time this tool ever captured AppConfig at Standard
        // tier). Must be scoped to this one armType: KeyVault uses the exact same label for a real,
        // directly-traceable properties.enableSoftDelete boolean, and already resolves correctly
        // through the ordinary generic/boolean paths below — a blanket NonTraceableLabels entry for
        // "Soft-delete" would have silently broken that (caught by
        // TemplateGeneratorTests.Generate_BooleanField_UsesEnabledDisabledTransform_WhenCapturedValueIsEnabled).
        if (label.Equals("Soft-delete", StringComparison.OrdinalIgnoreCase)
            && armType.Equals("Microsoft.AppConfiguration/configurationStores", StringComparison.OrdinalIgnoreCase))
        {
            return new FieldRecipe(FieldRecipeKind.Unresolved, 0.0, null,
                "Purely a SKU-tier feature-availability flag on this type (Standard tier always shows " +
                "Enabled, Free tier always shows N/A) — no backing property at all, confirmed live " +
                "2026-08-14. Distinct from KeyVault's same-named label, which really is a direct " +
                "properties.enableSoftDelete passthrough.");
        }
        if (label.Equals("Name", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveNameShortcut(value, root);
        }
        if (label.Equals("Location", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveLocationShortcut(value, root);
        }
        if (label.Equals("Resource group", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveResourceGroupShortcut(value, root);
        }
        if (label.Equals("Replication", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveStorageReplicationShortcut(value, root);
        }
        if (label.Equals("Account kind", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveStorageAccountKindShortcut(value, root);
        }
        if (label.Equals("Performance", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveShortcutOrUnverified(value, PortalFriendlyLabels.StoragePerformanceLabel(root),
                "model.storage_performance_label",
                "This capture has no sku.tier, or kind is \"FileStorage\" (the Media Tier text wasn't traced)");
        }
        if (label.Equals("Storage type", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveDiskStorageTypeShortcut(value, root);
        }
        if (label.Equals("Security type", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveDiskSecurityTypeShortcut(value, root);
        }
        if (label.Equals("Cluster tier", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveShortcutOrUnverified(value, PortalFriendlyLabels.MongoClusterTierLabel(root),
                "model.mongo_cluster_tier_label", "properties.compute.tier isn't in the known tier table");
        }
        if (label.Equals("Connectivity method", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveShortcutOrUnverified(value, PortalFriendlyLabels.MongoConnectivityMethodLabel(root),
                "model.mongo_connectivity_method_label", "This capture has no properties.publicNetworkAccess");
        }
        if (label.Equals("Authentication", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveShortcutOrUnverified(value, PortalFriendlyLabels.MongoAuthenticationLabel(root),
                "model.mongo_authentication_label",
                "properties.authConfig.allowedModes is empty/absent, or matches neither known auth mode");
        }
        if (label.Equals("Storage encryption", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveVerifiedShortcut(value, PortalFriendlyLabels.MongoStorageEncryptionLabel(root),
                "model.mongo_storage_encryption_label");
        }
        if (label.Equals("Definition", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveShortcutOrUnverified(value, PortalFriendlyLabels.LogicWorkflowDefinitionLabel(root),
                "model.logic_workflow_definition_label", "This capture has no properties.definition object");
        }
        if (label.Equals("Integration Account", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveVerifiedShortcut(value, PortalFriendlyLabels.LogicIntegrationAccountLabel(root),
                "model.logic_integration_account_label");
        }
        if (label.Equals("Workflow Type", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveShortcutOrUnverified(value, PortalFriendlyLabels.LogicWorkflowTypeLabel(root),
                "model.logic_workflow_type_label",
                "properties.definition.metadata.agentType is set — the Autonomous/Conversational-agent " +
                "branches weren't traced this session, only the default \"Stateful\" case");
        }
        if (label.Equals("Telemetry", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveVerifiedShortcut(value, PortalFriendlyLabels.AppConfigTelemetryLabel(root),
                "model.appconfig_telemetry_label");
        }
        if (label.Equals("Power state", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveVerifiedShortcut(value, PortalFriendlyLabels.AksPowerStateLabel(root),
                "model.aks_power_state_label");
        }
        if (label.Equals("Cluster operation status", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveVerifiedShortcut(value, PortalFriendlyLabels.AksClusterOperationStatusLabel(root),
                "model.aks_cluster_operation_status_label");
        }
        if (label.Equals("API server address", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveVerifiedShortcut(value, PortalFriendlyLabels.AksApiServerAddressLabel(root),
                "model.aks_api_server_address_label");
        }
        if (label.Equals("Node pools", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveVerifiedShortcut(value, PortalFriendlyLabels.AksNodePoolsLabel(root),
                "model.aks_node_pools_label");
        }
        if (label.Equals("Network configuration", StringComparison.OrdinalIgnoreCase))
        {
            return ResolveShortcutOrUnverified(value, PortalFriendlyLabels.AksNetworkConfigurationLabel(root),
                "model.aks_network_configuration_label",
                "properties.networkProfile.networkPlugin is missing, or is \"azure\" without overlay mode or " +
                "any pod-subnet-attached node pool (the older non-overlay/non-podsubnet Azure CNI text wasn't traced)");
        }

        var (baseLabel, _) = StripParenthetical(label);
        if (SkuLikeTokens.Any(t => Tokenize(baseLabel).Contains(t)))
        {
            return ResolveSkuShortcut(value, root);
        }

        if (PortalFieldKnowledge.TenantIdentityAllowedValues.TryGetValue(label, out var allowed))
        {
            return allowed.Contains(value, StringComparer.Ordinal)
                ? new FieldRecipe(FieldRecipeKind.Context, 1.0, null,
                    "Tenant/subscription identity — already covered by frontmatter, omit from body")
                : new FieldRecipe(FieldRecipeKind.Context, 0.0, null,
                    $"WARNING: value \"{value}\" doesn't match the expected placeholder " +
                    $"({string.Join(" / ", allowed)}) — check OutputNormalizer redaction before trusting this capture");
        }

        if (PortalFieldKnowledge.TimestampLabels.Contains(label))
        {
            return ResolveTimestamp(baseLabel, value, root);
        }

        if (PortalFieldKnowledge.BooleanBackedLabels.ContainsKey(label))
        {
            return ResolveKnownBoolean(label, value, root);
        }

        if (PortalFieldKnowledge.NonTraceableLabels.Contains(label) && !AttemptDespiteNonTraceableHint.Contains(label))
        {
            var hint = PortalFieldKnowledge.UnresolvedLabelHints.TryGetValue(label, out var h)
                ? h
                : "composite/derived — no single backing property (see NonTraceableLabels comments)";
            return new FieldRecipe(FieldRecipeKind.Unresolved, 0.0, null, hint);
        }

        var generic = ResolveGeneric(baseLabel, value, root);

        // The generic resolver found nothing for THIS specific (armType, label) — fall back to the
        // richer, previously-known reason (e.g. "vocabulary" / "composite of X + Y") instead of its
        // generic "no value match found" message, so a type where this genuinely doesn't resolve
        // still reads as informative as it did before AttemptDespiteNonTraceableHint existed.
        if (generic.Kind == FieldRecipeKind.Unresolved
            && PortalFieldKnowledge.UnresolvedLabelHints.TryGetValue(label, out var fallbackHint))
        {
            return generic with { Notes = fallbackHint };
        }

        return generic;
    }

    private static FieldRecipe ResolveSkuShortcut(string value, JsonElement root)
    {
        var computed = SkuAndVersion.SkuLabel(root);
        if (computed is null)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutMismatch, 0.0, "model.sku_label",
                $"portal shows \"{value}\" but no sku object found at root or properties.sku");
        }
        if (computed == value)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutVerified, 1.0, "model.sku_label",
                "Verified: computed sku_label matches the captured portal value exactly.");
        }
        if (PortalFieldKnowledge.Normalize(computed) == PortalFieldKnowledge.Normalize(value))
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutCasingMismatch, 0.7, "model.sku_label",
                $"Computed \"{computed}\" vs portal \"{value}\" — same value, different casing/formatting. " +
                "Usable, but the renderer needs its own text fixup to match the portal exactly.");
        }

        // The combined "Tier (Name)" shape doesn't always win — some types render sku.tier and
        // sku.name as two separate direct-passthrough Essentials fields instead of ever combining
        // them (AKS confirmed live 2026-08-14: "Sku" = bare sku.name, "Pricing tier" = bare sku.tier).
        // Try both bare forms before giving up, each pointing at its own bare model field (NOT
        // model.sku_label, which would still render the combined form and be wrong here).
        if (SkuAndVersion.SkuTier(root) is { } tier && tier == value)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutVerified, 1.0, "model.sku_tier",
                "Verified: matches the bare sku.tier value exactly — this type renders tier/name as " +
                "separate fields rather than SkuLabel's combined \"Tier (Name)\" shape.");
        }
        if (SkuAndVersion.SkuName(root) is { } name && name == value)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutVerified, 1.0, "model.sku_name",
                "Verified: matches the bare sku.name value exactly — this type renders tier/name as " +
                "separate fields rather than SkuLabel's combined \"Tier (Name)\" shape.");
        }
        return new FieldRecipe(FieldRecipeKind.ShortcutMismatch, 0.0, "model.sku_label",
            $"Computed \"{computed}\" does NOT match portal \"{value}\" for this type — do not trust this shortcut here.");
    }

    // Live-found (2026-08-18): "Name" was blanket-classified NonTraceableLabels on the strength of a
    // single observed case (Portal/dashboards renders "{resourceName} ({friendly title})") — but
    // checking all 10 captured types that actually show a "Name" Essentials row found 9 of them are
    // a plain, exact passthrough of the resource's own root "name" field; dashboards is the one
    // genuine composite. Dedicated shortcut (verify-or-fall-back, same shape as
    // ResolveLocationShortcut/ResolveResourceGroupShortcut below) so the 9 plain cases resolve
    // confidently instead of every type paying for the one composite exception.
    private static FieldRecipe ResolveNameShortcut(string value, JsonElement root)
    {
        var rawName = JsonTree.GetString(root, "name");
        if (rawName is null)
        {
            return new FieldRecipe(FieldRecipeKind.Unresolved, 0.0, null, "This capture has no root 'name' field.");
        }
        if (rawName == value)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutVerified, 1.0, "model.name",
                "Verified: matches the resource's own 'name' field exactly.");
        }
        if (string.Equals(rawName, value, StringComparison.OrdinalIgnoreCase))
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutCasingMismatch, 0.7, "model.name",
                $"Raw \"{rawName}\" vs portal \"{value}\" — same value, different casing.");
        }
        if (value.StartsWith(rawName, StringComparison.Ordinal))
        {
            // The dashboards case: "{name} ({friendly title})" — model.name is genuinely the right
            // lead, just missing a trailing composite this capture has no traceable source for, so
            // NeedsReview (still points at the right target) rather than a flat ShortcutMismatch
            // (which would wrongly suggest model.name itself is the wrong answer here).
            return new FieldRecipe(FieldRecipeKind.NeedsReview, 0.5, "model.name",
                $"Portal value \"{value}\" starts with the resource's own name (\"{rawName}\") but carries " +
                "extra trailing text this capture can't trace (e.g. a friendly display title) — verify by hand.");
        }
        return new FieldRecipe(FieldRecipeKind.ShortcutMismatch, 0.0, "model.name",
            $"Resource's own name is \"{rawName}\" but the portal showed \"{value}\" — investigate before " +
            "trusting this shortcut here.");
    }

    // "norwayeast" -> "Norway East" via config/azure-locations.json (fetch-azure-reference-data.ps1)
    // — the raw ARM location code is never the portal's display text, so this always needed a real
    // lookup, not just a path. Normalize()-equality alone would already bridge most regions (they're
    // literally the display name with spaces/casing stripped), but the fetched table is used instead
    // of relying on that always holding — it's the authoritative source, not an assumption.
    private static FieldRecipe ResolveLocationShortcut(string value, JsonElement root)
    {
        var rawLocation = JsonTree.GetString(root, "location");
        if (rawLocation is null)
        {
            return new FieldRecipe(FieldRecipeKind.Unresolved, 0.0, null, "This capture has no root 'location' field.");
        }

        // Not every resource provider returns the usual lowercase ARM code — live-observed:
        // Notification Hubs, App Service Plans, and others return "location" already in display
        // form ("Norway East"), and non-regional values like "global"/"Global" are legitimate,
        // stable location values with no entry in the physical-regions-only lookup table anyway.
        // Check direct equality before consulting the lookup, so both shapes verify correctly
        // instead of the display-form/global cases falling through to "not in table".
        if (rawLocation == value)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutVerified, 1.0, "model.location",
                "Verified: this capture's raw 'location' is already in display form, matches the portal exactly.");
        }
        if (string.Equals(rawLocation, value, StringComparison.OrdinalIgnoreCase))
        {
            // e.g. Azure Maps: raw "global" vs portal "Global" — a non-regional value, so it was
            // never going to be in the physical-regions lookup below either way.
            return new FieldRecipe(FieldRecipeKind.ShortcutCasingMismatch, 0.7, "model.location",
                $"Raw \"{rawLocation}\" vs portal \"{value}\" — same value, different casing.");
        }

        if (!RegionDisplayNames.TryGetDisplayName(rawLocation, out var displayName))
        {
            return new FieldRecipe(FieldRecipeKind.Shortcut, 0.3, "model.location",
                $"Region '{rawLocation}' isn't in config/azure-locations.json (stale fetch, or a new/preview " +
                "region) — falling back to the raw ARM value, unverified. Re-run fetch-azure-reference-data.ps1.");
        }

        if (displayName == value)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutVerified, 1.0, "model.location",
                "Verified via config/azure-locations.json — transform: region_display_name.");
        }

        return new FieldRecipe(FieldRecipeKind.ShortcutMismatch, 0.0, "model.location",
            $"config/azure-locations.json says '{rawLocation}' displays as \"{displayName}\", but the portal " +
            $"showed \"{value}\" — investigate before trusting this shortcut for this type.");
    }

    private static readonly Regex ResourceGroupFromId = new(@"/resourceGroups/([^/]+)/", RegexOptions.IgnoreCase | RegexOptions.Compiled);

    // The resource group name isn't a separate field in a raw ARM GET response — only embedded in
    // `id` — but since OutputNormalizer redacts it to the same placeholder everywhere it appears
    // (both inside `id` and in the portal's own "Resource group" field), no formatting transform is
    // needed here, just extraction and an exact comparison.
    private static FieldRecipe ResolveResourceGroupShortcut(string value, JsonElement root)
    {
        var id = JsonTree.GetString(root, "id");
        var match = id is null ? null : ResourceGroupFromId.Match(id);
        if (match is not { Success: true })
        {
            return new FieldRecipe(FieldRecipeKind.Unresolved, 0.0, null,
                "Couldn't extract a resource group name from this capture's 'id' field.");
        }

        var extracted = match.Groups[1].Value;
        if (extracted == value)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutVerified, 1.0, "model.resource_group",
                "Verified: resource group name extracted from 'id' matches the portal value exactly.");
        }
        if (string.Equals(extracted, value, StringComparison.OrdinalIgnoreCase))
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutCasingMismatch, 0.7, "model.resource_group",
                $"Extracted \"{extracted}\" vs portal \"{value}\" — same value, different casing.");
        }
        return new FieldRecipe(FieldRecipeKind.ShortcutMismatch, 0.0, "model.resource_group",
            $"Extracted \"{extracted}\" from 'id' but the portal showed \"{value}\" — investigate.");
    }

    // The four shortcuts below (Replication/Account kind on Storage Accounts, Storage type/Security
    // type on Compute/disks) were previously in PortalFieldKnowledge.NonTraceableLabels as
    // "composite/derived, no single backing property" — wrong, just incomplete: each is a plain enum
    // property run through a friendly-name lookup table that defeats plain value-matching (the
    // rendered text never appears anywhere in the raw JSON). Unlike a guessed table, every entry in
    // PortalFriendlyLabels was read directly out of the live Azure Portal's own already-loaded,
    // unminified-enough JS (2026-08-14 — see EssentialsExtractor.DumpFiberBuilderSourceAsync's class
    // comment and AGENT.md for the two-step technique: find the field-builder function via the fiber
    // walk, then find the *other* already-loaded chunk containing that function's own enum-switch and
    // resource-string table, by fetching every script the frame loaded via
    // `performance.getEntriesByType('resource')` and searching each for a snippet unique to the
    // already-known call site). Same "live-verified, never guessed" bar as config/azure-locations.json,
    // just sourced from portal JS instead of a fetched docs page. The lookup tables themselves live in
    // PortalFriendlyLabels, shared with ScribanModelBuilder so a rendered preview and this resolver's
    // verification can never quietly disagree (same reasoning as SkuAndVersion below).
    private static FieldRecipe ResolveStorageReplicationShortcut(string value, JsonElement root)
    {
        var computed = PortalFriendlyLabels.StorageReplicationLabel(root);
        if (computed is null)
        {
            return new FieldRecipe(FieldRecipeKind.Shortcut, 0.3, "model.storage_replication_label",
                "sku.name isn't in the known redundancy-category table (2026-08-14 portal source dump) — " +
                "either a new SKU or this capture has no sku.name at all. Unverified.");
        }
        if (computed == value)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutVerified, 1.0, "model.storage_replication_label",
                "Verified: sku.name -> redundancy category -> resource-string text, all read from the live " +
                "portal's own JS (2026-08-14) — matches the captured value exactly.");
        }
        return new FieldRecipe(FieldRecipeKind.ShortcutMismatch, 0.0, "model.storage_replication_label",
            $"Computed \"{computed}\" does NOT match portal \"{value}\" — investigate before trusting this " +
            "shortcut for this capture.");
    }

    private static FieldRecipe ResolveStorageAccountKindShortcut(string value, JsonElement root)
    {
        var computed = PortalFriendlyLabels.StorageAccountKindLabel(root);
        if (computed is null)
        {
            return new FieldRecipe(FieldRecipeKind.Unresolved, 0.0, null, "This capture has no root 'kind' field.");
        }
        if (computed == value)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutVerified, 1.0, "model.storage_account_kind_label",
                "Verified: kind -> StorageAccount_Kind resource-string format, read from the live portal's " +
                "own JS (2026-08-14) — matches the captured value exactly.");
        }
        return new FieldRecipe(FieldRecipeKind.ShortcutMismatch, 0.0, "model.storage_account_kind_label",
            $"Computed \"{computed}\" does NOT match portal \"{value}\" — this capture's 'id' may look like a " +
            "classic-era resource ID (a case this shortcut doesn't replicate), or the kind is a value this " +
            "table doesn't cover yet — investigate before trusting.");
    }

    private static FieldRecipe ResolveDiskStorageTypeShortcut(string value, JsonElement root)
    {
        var computed = PortalFriendlyLabels.DiskStorageTypeLabel(root);
        if (computed is null)
        {
            return new FieldRecipe(FieldRecipeKind.Shortcut, 0.3, "model.disk_storage_type_label",
                "sku.name isn't in the known disk-type table (2026-08-14 portal source dump) — either a new " +
                "SKU or this capture has no sku.name at all. Unverified.");
        }
        if (computed == value)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutVerified, 1.0, "model.disk_storage_type_label",
                "Verified: sku.name -> disk-type resource-string text, read from the live portal's own JS " +
                "(2026-08-14) — matches the captured value exactly.");
        }
        return new FieldRecipe(FieldRecipeKind.ShortcutMismatch, 0.0, "model.disk_storage_type_label",
            $"Computed \"{computed}\" does NOT match portal \"{value}\" — investigate before trusting this " +
            "shortcut for this capture.");
    }

    private static FieldRecipe ResolveDiskSecurityTypeShortcut(string value, JsonElement root)
    {
        var computed = PortalFriendlyLabels.DiskSecurityTypeLabel(root);
        if (computed == value)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutVerified, 1.0, "model.disk_security_type_label",
                "Verified: properties.securityProfile.securityType -> security-type resource-string text, " +
                "read from the live portal's own JS (2026-08-14) — matches the captured value exactly " +
                "(including the no-securityProfile-at-all -> \"Standard\" fallback the portal's own code takes).");
        }
        return new FieldRecipe(FieldRecipeKind.ShortcutMismatch, 0.0, "model.disk_security_type_label",
            $"Computed \"{computed}\" does NOT match portal \"{value}\" — investigate before trusting this " +
            "shortcut for this capture.");
    }

    // Second pass (same day, follow-up investigation across DocumentDB/mongoClusters,
    // Logic/workflows, and AppConfiguration/configurationStores) over the same "friendly-name lookup
    // defeats value-matching" problem — see PortalFriendlyLabels for each field's own provenance
    // comment. These two helpers cover the two shapes that kept repeating: a lookup that's either
    // fully known (a "Standard"-style unconditional default — Storage encryption, Integration
    // Account, Telemetry) or can come back null for an input this session didn't trace (an unknown
    // SKU/tier, an untraced agent-workflow branch — Cluster tier, Connectivity method, Authentication,
    // Definition, Workflow Type), in which case the recipe stays a low-confidence, explicitly-labeled
    // "Shortcut" rather than a false "Unresolved — no idea", and reports as ShortcutMismatch (not
    // silently trusted) if what's computed for the KNOWN cases doesn't actually match this capture.
    private static FieldRecipe ResolveVerifiedShortcut(string value, string computed, string target)
    {
        if (computed == value)
        {
            return new FieldRecipe(FieldRecipeKind.ShortcutVerified, 1.0, target,
                "Verified: matches the captured value exactly (2026-08-14 live portal source read — see " +
                "PortalFriendlyLabels for this field's own provenance).");
        }
        return new FieldRecipe(FieldRecipeKind.ShortcutMismatch, 0.0, target,
            $"Computed \"{computed}\" does NOT match portal \"{value}\" — investigate before trusting this " +
            "shortcut for this capture.");
    }

    private static FieldRecipe ResolveShortcutOrUnverified(string value, string? computed, string target, string unknownReason)
    {
        if (computed is null)
        {
            return new FieldRecipe(FieldRecipeKind.Shortcut, 0.3, target, $"{unknownReason}. Unverified.");
        }
        return ResolveVerifiedShortcut(value, computed, target);
    }

    private static FieldRecipe ResolveTimestamp(string baseLabel, string value, JsonElement root)
    {
        var allPaths = PortalFieldKnowledge.FindTimestampMatchingPaths(value, root);
        var addressable = allPaths.Where(p => p.StartsWith("properties.", StringComparison.Ordinal)).ToList();

        if (addressable.Count > 0)
        {
            var best = RankByNameSimilarity(baseLabel, addressable);
            var target = $"model.props.{StripPropertiesPrefix(best)}";
            return new FieldRecipe(FieldRecipeKind.Timestamp, 0.9, target,
                addressable.Count > 1
                    ? $"transform: portal_timestamp — {addressable.Count} candidate instants matched, picked by label/property-name similarity"
                    : "transform: portal_timestamp");
        }

        if (allPaths.Count > 0)
        {
            return new FieldRecipe(FieldRecipeKind.NotAddressable, 0.0, null,
                $"Traceable via '{allPaths[0]}', but that's outside properties.* — not reachable as model.props.*. " +
                "Would need the renderer to expose that section, or the label stays manual.");
        }

        return new FieldRecipe(FieldRecipeKind.TimestampUnresolved, 0.0, null,
            "Labeled as a timestamp but no matching ISO instant found anywhere in this capture.");
    }

    private static FieldRecipe ResolveKnownBoolean(string label, string value, JsonElement root)
    {
        var path = PortalFieldKnowledge.FindBooleanBackedPath(label, value, root);
        if (path is null)
        {
            return new FieldRecipe(FieldRecipeKind.Unresolved, 0.0, null,
                $"Expected boolean-backed property for '{label}' not found in this capture.");
        }
        if (!path.StartsWith("properties.", StringComparison.Ordinal))
        {
            return new FieldRecipe(FieldRecipeKind.NotAddressable, 0.0, null,
                $"Traceable via '{path}', but that's outside properties.* — not reachable as model.props.*.");
        }
        return new FieldRecipe(FieldRecipeKind.Boolean, 0.95, $"model.props.{StripPropertiesPrefix(path)}",
            "transform: portal_bool (known-verified label→property mapping)");
    }

    // Dual-signal resolution for everything not already covered by a known table: a value match
    // alone isn't enough — short friendly words like "Enabled"/"2"/"Basic" collide across unrelated
    // properties in a typical ARM properties bag — so rank candidates by how closely the label's
    // words resemble the matched property's own name, and only take a value match at face value
    // when it's also the best name match.
    //
    // Searches the WHOLE document, not just properties.* — a first pass that scoped this to
    // properties.* alone missed real matches sitting in ARM's root-level "kind"/"name"/"id" blocks
    // (sibling to properties, not inside it). Addressability is then judged per-candidate via
    // AddressableTarget: a match under properties.* or one of the handful of first-class model
    // fields is usable; anything else (systemData, tags, sku's raw name/tier once already covered
    // by the SKU shortcut, etc.) is traceable but not reachable from a template, and reported as
    // NotAddressable instead of a misleading blanket "no match found".
    private static FieldRecipe ResolveGeneric(string baseLabel, string value, JsonElement root)
    {
        var nVal = PortalFieldKnowledge.Normalize(value);
        var candidates = new List<(string ScribanPath, string OriginalPath, double Similarity, string Reason, string? Suffix)>();

        foreach (var leaf in JsonTree.Flatten(root))
        {
            var (matched, reason, suffix) = TryMatchLeafValue(leaf.Value, nVal, value);
            if (!matched)
            {
                continue;
            }
            candidates.Add((leaf.ScribanPath, leaf.OriginalPath, NameSimilarity(baseLabel, leaf.OriginalPath), reason, suffix));
        }

        if (candidates.Count == 0)
        {
            return new FieldRecipe(FieldRecipeKind.Unresolved, 0.0, null,
                "No value match found anywhere in this capture — investigate before adding to any known table " +
                "(could be a genuine EssentialsExtractor/redaction bug, a portal empty-state placeholder like " +
                "\"---\", or a new different-API-surface/composite case).");
        }

        candidates = candidates.OrderByDescending(c => c.Similarity).ToList();
        var bestOverall = candidates[0];
        var addressable = candidates
            .Select(c => (c.ScribanPath, c.Similarity, c.Reason, c.Suffix, Target: AddressableTarget(c.OriginalPath, c.ScribanPath)))
            .Where(c => c.Target is not null)
            .OrderByDescending(c => c.Similarity)
            .ToList();

        if (addressable.Count == 0)
        {
            return new FieldRecipe(FieldRecipeKind.NotAddressable, 0.0, null,
                $"Traceable via '{bestOverall.ScribanPath}' ({bestOverall.Reason}), but that's outside " +
                "properties.*/kind/name/id/location — not reachable from a template.");
        }

        var best = addressable[0];
        var runnerUp = addressable.Count > 1 ? addressable[1] : default;

        // A single weak token match (e.g. "messages" fuzzy-stemming against "message", or a
        // generic word like "managed" appearing in an otherwise unrelated property path) is not
        // enough to trust blindly — that's exactly how "Forward messages to" matched
        // deadLetteringOnMessageExpiration and "Managed virtual network" matched
        // defaultDataLakeStorage.createManagedPrivateEndpoint, both wrong, both live-caught here.
        // Require at least half the label's words to be reflected in the property name before
        // calling it Direct.
        if (best.Similarity < 0.5)
        {
            var alt = addressable.Count > 1
                ? $" ({addressable.Count} addressable value-matching leaves, none strongly name-related to the label)"
                : "";
            return new FieldRecipe(FieldRecipeKind.NeedsReview, 0.2, best.Target,
                $"Value matches ({best.Reason}) but the property name is only weakly related to the label " +
                $"(similarity {best.Similarity.ToString("0.00", CultureInfo.InvariantCulture)}) — " +
                $"verify by hand before trusting{alt}.");
        }

        if (runnerUp != default
            && runnerUp.Similarity >= best.Similarity - 0.01
            && runnerUp.Target != best.Target)
        {
            return new FieldRecipe(FieldRecipeKind.Ambiguous, best.Similarity, best.Target,
                $"Tied with {runnerUp.Target} " +
                $"(similarity {runnerUp.Similarity.ToString("0.00", CultureInfo.InvariantCulture)}) — pick manually.");
        }

        return new FieldRecipe(FieldRecipeKind.Direct, best.Similarity, best.Target, best.Reason, LiteralSuffix: best.Suffix);
    }

    // The handful of places outside properties.* that a template can still reach: properties.* maps
    // to model.props.*; ARM's root-level "kind" column is merged into model.props.kind whenever
    // properties doesn't already define it (Cognitive Services' "API Kind", etc.); "name"/"id" are
    // their own first-class model fields. Everything else found elsewhere in the document (tags,
    // systemData, identity, sku's raw sub-fields once the SKU shortcut already covers those,
    // cross-referenced related-resource IDs) is real data but genuinely not template-addressable
    // today.
    private static string? AddressableTarget(string originalPath, string scribanPath)
    {
        // sku.capacity (root-level, or properties-nested on the handful of types that nest their
        // whole sku object — same dual lookup as SkuAndVersion.SkuObject) needs its own first-class
        // model field rather than falling through to the generic "properties.* -> model.props.*"
        // rule below, since a root-level "sku.capacity" isn't under properties.* at all and would
        // otherwise be reported NotAddressable even after a genuine value match (live-caught:
        // SignalR/WebPubSub's "Unit" both traced to sku.capacity but couldn't be referenced).
        if (originalPath.Equals("sku.capacity", StringComparison.OrdinalIgnoreCase)
            || originalPath.Equals("properties.sku.capacity", StringComparison.OrdinalIgnoreCase))
        {
            return "model.sku_capacity";
        }
        if (originalPath.StartsWith("properties.", StringComparison.OrdinalIgnoreCase))
        {
            return $"model.props.{StripPropertiesPrefix(scribanPath)}";
        }
        return originalPath.ToLowerInvariant() switch
        {
            "kind" => "model.props.kind",
            "name" => "model.name",
            "id" => "model.id",
            "location" => "model.location",
            "type" => "model.type",
            _ => null,
        };
    }

    private static (bool Matched, string Reason, string? Suffix) TryMatchLeafValue(
        JsonElement leaf, string normalizedPortalValue, string rawPortalValue)
    {
        if (leaf.ValueKind is JsonValueKind.True or JsonValueKind.False)
        {
            var isTrue = leaf.ValueKind is JsonValueKind.True;
            string[] words = isTrue ? ["Enabled", "Yes", "On"] : ["Disabled", "No", "Off", "Not enabled"];
            return words.Any(w => PortalFieldKnowledge.Normalize(w) == normalizedPortalValue)
                ? (true, "boolean→friendly-word", null)
                : (false, "", null);
        }

        var leafText = leaf.ValueKind switch
        {
            JsonValueKind.String => leaf.GetString(),
            JsonValueKind.Number => leaf.GetRawText(),
            _ => null,
        };
        if (leafText is not null
            && normalizedPortalValue.Length > 0
            && PortalFieldKnowledge.Normalize(leafText) == normalizedPortalValue)
        {
            return (true, "exact value match", null);
        }

        // Live-found (2026-08-18): the portal often renders a raw JSON number with a trailing unit
        // word the property itself never carries — "30 Seconds" for originResponseTimeoutSeconds:30,
        // "4 GiB" for diskSizeGB:4, "1 unit"/"1 capacity units" for sku.capacity:1 — so plain
        // normalized-string equality (which strips spaces/punctuation but not whole words) can never
        // bridge it; "30seconds" != "30". Only trusted for a genuine JSON number leaf whose value
        // equals the label's LEADING number, AND only when the trailing text is plain unit-word(s)
        // (letters/spaces only) — live-caught the case this guard exists for: Search Services'
        // "Replicas" = "1 (No SLA)" would otherwise bake "(No SLA)" in as a literal suffix on every
        // future render regardless of the actual replica count, since that parenthetical is a
        // conditional annotation the portal only adds when the count is exactly 1, not a constant
        // unit of measurement — a single captured example can't tell those two shapes apart, so
        // anything other than bare words after the number is left unmatched (Unresolved) rather
        // than risk confidently rendering a suffix that's only sometimes true.
        if (leaf.ValueKind == JsonValueKind.Number)
        {
            var leadingNumber = Regex.Match(rawPortalValue.TrimStart(), @"^-?\d+(\.\d+)?");
            if (leadingNumber.Success
                && double.TryParse(leadingNumber.Value, NumberStyles.Float, CultureInfo.InvariantCulture, out var portalNumber)
                && leaf.TryGetDouble(out var leafNumber)
                && portalNumber == leafNumber)
            {
                var suffix = rawPortalValue[leadingNumber.Length..];
                if (Regex.IsMatch(suffix, @"^\s+[A-Za-z]+(\s+[A-Za-z]+)*$"))
                {
                    return (true, "numeric value match (unit suffix stripped)", suffix);
                }
            }
        }

        return (false, "", null);
    }

    private static string StripPropertiesPrefix(string scribanPath) =>
        scribanPath.StartsWith("properties.", StringComparison.Ordinal)
            ? scribanPath["properties.".Length..]
            : scribanPath;

    // Live-found (2026-08-18): NameSimilarity alone is recall-only — "how much of the LABEL's
    // tokens appear in the path" — so "properties.creationTime" and
    // "properties.keyCreationTime.key1" score identically against "Created" (both fully contain
    // its one token, post-stemming), even though the latter carries an extra "key" token the label
    // says nothing about. Token count as a tie-break prefers the more direct property over a
    // deeper/more-qualified one carrying unexplained extra tokens — narrowly scoped to this one
    // ranking function (used only by ResolveTimestamp, not the broader generic resolver), not a
    // change to NameSimilarity's own scoring used everywhere else in this file.
    private static string RankByNameSimilarity(string baseLabel, IReadOnlyList<string> scribanPaths) =>
        scribanPaths
            .Select(p => (Path: p, Score: NameSimilarity(baseLabel, p), TokenCount: Tokenize(p).Count))
            .OrderByDescending(p => p.Score)
            .ThenBy(p => p.TokenCount)
            .First()
            .Path;

    private static (string Base, string? Parenthetical) StripParenthetical(string label)
    {
        var m = Regex.Match(label, @"^(.*?)\s*\(([^)]+)\)\s*$");
        return m.Success ? (m.Groups[1].Value.Trim(), m.Groups[2].Value) : (label, null);
    }

    private static HashSet<string> Tokenize(string s)
    {
        var tokens = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (var word in Regex.Split(s, @"[^A-Za-z]+").Where(w => w.Length > 0))
        {
            foreach (var part in Regex.Split(word, "(?<=[a-z0-9])(?=[A-Z])"))
            {
                if (part.Length > 0)
                {
                    tokens.Add(part.ToLowerInvariant());
                }
            }
        }
        return tokens;
    }

    private static double NameSimilarity(string label, string propertyPath)
    {
        var labelTokens = Tokenize(label);
        if (labelTokens.Count == 0)
        {
            return 0;
        }
        var pathTokens = Tokenize(propertyPath);
        var hits = labelTokens.Count(lt => pathTokens.Any(pt =>
            pt.Equals(lt, StringComparison.OrdinalIgnoreCase)
            || pt.StartsWith(lt, StringComparison.OrdinalIgnoreCase)
            || lt.StartsWith(pt, StringComparison.OrdinalIgnoreCase)
            || Stem(pt).Equals(Stem(lt), StringComparison.OrdinalIgnoreCase)));
        return (double)hits / labelTokens.Count;
    }

    // Live-found (2026-08-18): "Created" (tokenizes to "created") scored 0 similarity against
    // "creationTime" (tokenizes to "creation"/"time") — neither is a StartsWith-prefix of the
    // other ("created"/"creation" diverge at their 6th letter, e/i) despite sharing the same root.
    // This let Storage Accounts' "Created" tie-break arbitrarily against "keyCreationTime.key1" (a
    // property that happens to hold nearly the same instant, since the account and its access key
    // are created together) instead of clearly preferring the actual creation-time property — a
    // generic gap in the resolver's semantic-agreement check, not a Storage-Account-specific one,
    // so any label/property pair with this same -ed/-ion (or similar) suffix mismatch was at risk
    // of the same silent tie-break. Fixed with a small, deliberately narrow suffix list — common
    // English inflections only, not a general-purpose stemmer — to keep the false-positive risk low
    // (e.g. "creature" stems to "creatur", not "creat", so it doesn't collide with "created").
    private static readonly string[] CommonSuffixes = ["ing", "ion", "ed", "es", "s", "e"];

    private static string Stem(string token)
    {
        foreach (var suffix in CommonSuffixes)
        {
            // Require at least 3 characters left after stripping, so short tokens ("id", "as")
            // can't be hollowed out into a near-empty, over-eager-matching stem.
            if (token.Length >= suffix.Length + 3 && token.EndsWith(suffix, StringComparison.OrdinalIgnoreCase))
            {
                return token[..^suffix.Length];
            }
        }
        return token;
    }
}
