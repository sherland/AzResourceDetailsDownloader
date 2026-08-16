# appcs1y-1kv59

| Property | Value |
|---|---|
| **Resource group** | rg-ardl-833890ef5c1b6d5f |
| **Status** | *See the Azure Portal for current status.* |
| **Location** | Norway East |
<!-- "Subscription" omitted: tenant/subscription identity, already in frontmatter -->
<!-- "Subscription ID" omitted: tenant/subscription identity, already in frontmatter -->
| **Endpoint** | https://appcs1y-1kv59.azconfig.io |
| **Pricing tier** | Free (Click to upgrade) |
| **Soft-delete** | <!-- TODO (Unresolved): Purely a SKU-tier feature-availability flag on this type (Standard tier always shows Enabled, Free tier always shows N/A) — no backing property at all, confirmed live 2026-08-14. Distinct from KeyVault's same-named label, which really is a direct properties.enableSoftDelete passthrough. --> N/A |
| **Purge protection** | <!-- TODO (Unresolved): properties.enablePurgeProtection, a real boolean — but only rendered at all on a SKU tier where the feature exists, so an unresolved capture may just mean the SKU didn't have the property to show (confirmed live on AppConfiguration/configurationStores) --> N/A |
| **Geo-replication** | <!-- TODO (Unresolved): AppConfiguration/configurationStores: the replica count comes from a separate replicas-list API call (e.replicas?.length in the portal's own source), not this type's resource GET body at all — genuinely a different-API-surface case, confirmed live 2026-08-14 on a Standard-tier store (the first time this tool ever captured one). --> N/A |
| **Telemetry** | Disabled |
