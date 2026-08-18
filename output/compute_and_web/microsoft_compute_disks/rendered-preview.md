# diskbpe8-oy2

| Property | Value |
|---|---|
| **Resource group** | rg-ardl-ab7325b8645ba734 |
| **Disk state** | Unattached |
| **Last ownership update time** | <!-- TODO (Unresolved): properties.LastOwnershipUpdateTime (note the unusual capital L — a real quirk in this property's ARM casing, not a typo) — a genuine timestamp, just null on every disk this tool has captured so far (confirmed live on Compute/disks) Captured example: "-" --> *Not available from captured ARM metadata.* |
| **Location** | Norway East |
<!-- "Subscription" omitted: tenant/subscription identity, already in frontmatter -->
<!-- "Subscription ID" omitted: tenant/subscription identity, already in frontmatter -->
| **Time created** | August 16, 2026 at 13:13:09 UTC |
| **Disk size** | <!-- TODO (Unresolved): No value match found anywhere in this capture — investigate before adding to any known table (could be a genuine EssentialsExtractor/redaction bug, a portal empty-state placeholder like "---", or a new different-API-surface/composite case). Captured example: "4 GiB" --> *Not available from captured ARM metadata.* |
| **Storage type** | Standard HDD LRS |
| **Managed by** | <!-- TODO (Unresolved): properties.managedBy (a VM resource ID, last path segment shown) when set — genuinely composite (extracts + link-wraps a name from an ID, like the Resource Group shortcut does), correctly non-traceable as a plain value match (confirmed live on Compute/disks) Captured example: "-" --> *Not available from captured ARM metadata.* |
| **Operating system** | <!-- TODO (NeedsReview): Value matches (exact value match) but the property name is only weakly related to the label (similarity 0.00) — verify by hand before trusting. Captured example: "Linux" --> *Not available from captured ARM metadata.* |
| **Max shares** | <!-- TODO (Unresolved): properties.maxShares, a real (usually-zero) number — direct passthrough, only renders as "0" because no captured disk has sharing enabled (confirmed live on Compute/disks) Captured example: "0" --> *Not available from captured ARM metadata.* |
| **Availability zone** | <!-- TODO (Unresolved): the root-level `zones` array (NOT under properties.*, so not template-addressable even once traced), joined/sorted, with a "No infrastructure redundancy required" fallback when empty (confirmed live on Compute/disks) Captured example: "No infrastructure redundancy required" --> *Not available from captured ARM metadata.* |
| **Security type** | Standard |
