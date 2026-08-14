# diskul7-e4-0

| Property | Value |
|---|---|
| **Resource group** | rg-ardl-ab7325b8645ba734 |
| **Disk state** | Unattached |
| **Last ownership update time** | <!-- TODO (Unresolved): properties.LastOwnershipUpdateTime (note the unusual capital L — a real quirk in this property's ARM casing, not a typo) — a genuine timestamp, just null on every disk this tool has captured so far (confirmed live on Compute/disks) --> - |
| **Location** | Norway East |
<!-- "Subscription" omitted: tenant/subscription identity, already in frontmatter -->
<!-- "Subscription ID" omitted: tenant/subscription identity, already in frontmatter -->
| **Time created** | August 14, 2026 at 12:15:31 UTC |
| **Disk size** | <!-- TODO (Unresolved): No value match found anywhere in this capture — investigate before adding to any known table (could be a genuine EssentialsExtractor/redaction bug, a portal empty-state placeholder like "---", or a new different-API-surface/composite case). --> 4 GiB |
| **Storage type** | <!-- TODO (Unresolved): sku.name, via an untraced SKU-to-friendly-name lookup (same shape as Storage Accounts' "Replication"/"Account kind", confirmed live on Compute/disks) --> Standard HDD LRS |
| **Managed by** | <!-- TODO (Unresolved): properties.managedBy (a VM resource ID, last path segment shown) when set — genuinely composite (extracts + link-wraps a name from an ID, like the Resource Group shortcut does), correctly non-traceable as a plain value match (confirmed live on Compute/disks) --> - |
| **Operating system** | <!-- TODO (Unresolved): No value match found anywhere in this capture — investigate before adding to any known table (could be a genuine EssentialsExtractor/redaction bug, a portal empty-state placeholder like "---", or a new different-API-surface/composite case). --> - |
| **Max shares** | <!-- TODO (Unresolved): properties.maxShares, a real (usually-zero) number — direct passthrough, only renders as "0" because no captured disk has sharing enabled (confirmed live on Compute/disks) --> 0 |
| **Availability zone** | <!-- TODO (Unresolved): the root-level `zones` array (NOT under properties.*, so not template-addressable even once traced), joined/sorted, with a "No infrastructure redundancy required" fallback when empty (confirmed live on Compute/disks) --> No infrastructure redundancy required |
| **Security type** | <!-- TODO (NotAddressable): Traceable via 'sku.tier' (exact value match), but that's outside properties.*/kind/name/id/location — not reachable from a template. --> Standard |
