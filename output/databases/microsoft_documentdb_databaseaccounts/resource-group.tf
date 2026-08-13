terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "4.80.0"
    }
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "res-0" {
  location   = "norwayeast"
  managed_by = ""
  name       = "rg-ardl-657bd609e27aba5f"
  tags = {
    armType    = "Microsoft.DocumentDB/databaseAccounts"
    createdUtc = "2026-08-14T10:29:42.4134757Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_cosmosdb_account" "res-1" {
  access_key_metadata_writes_enabled    = true
  analytical_storage_enabled            = false
  automatic_failover_enabled            = true
  burst_capacity_enabled                = false
  create_mode                           = ""
  default_identity_type                 = "FirstPartyIdentity"
  free_tier_enabled                     = false
  ip_range_filter                       = []
  is_virtual_network_filter_enabled     = false
  kind                                  = "GlobalDocumentDB"
  local_authentication_disabled         = false
  local_authentication_enabled          = true
  location                              = "swedencentral"
  minimal_tls_version                   = "Tls12"
  multiple_write_locations_enabled      = false
  name                                  = "cosmosd5q1iefd"
  network_acl_bypass_for_azure_services = false
  network_acl_bypass_ids                = []
  offer_type                            = "Standard"
  partition_merge_enabled               = false
  public_network_access_enabled         = true
  resource_group_name                   = azurerm_resource_group.res-0.name
  tags                                  = {}
  analytical_storage {
    schema_type = "WellDefined"
  }
  backup {
    interval_in_minutes = 240
    retention_in_hours  = 8
    storage_redundancy  = "Geo"
    tier                = ""
    type                = "Periodic"
  }
  capabilities {
    name = "EnableServerless"
  }
  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }
  geo_location {
    failover_priority = 0
    location          = "swedencentral"
    zone_redundant    = false
  }
}
resource "azurerm_cosmosdb_sql_role_definition" "res-8" {
  account_name        = "cosmosd5q1iefd"
  assignable_scopes   = [azurerm_cosmosdb_account.res-1.id]
  name                = "Cosmos DB Built-in Data Reader"
  resource_group_name = azurerm_resource_group.res-0.name
  role_definition_id  = "00000000-0000-0000-0000-000000000001"
  type                = "BuiltInRole"
  permissions {
    data_actions = ["Microsoft.DocumentDB/databaseAccounts/readMetadata", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/executeQuery", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/readChangeFeed"]
  }
}
resource "azurerm_cosmosdb_sql_role_definition" "res-9" {
  account_name        = "cosmosd5q1iefd"
  assignable_scopes   = [azurerm_cosmosdb_account.res-1.id]
  name                = "Cosmos DB Built-in Data Contributor"
  resource_group_name = azurerm_resource_group.res-0.name
  role_definition_id  = "00000000-0000-0000-0000-000000000002"
  type                = "BuiltInRole"
  permissions {
    data_actions = ["Microsoft.DocumentDB/databaseAccounts/readMetadata", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*"]
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-657bd609e27aba5f"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-657bd609e27aba5f/providers/Microsoft.DocumentDB/databaseAccounts/cosmosd5q1iefd"
  to = azurerm_cosmosdb_account.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-657bd609e27aba5f/providers/Microsoft.DocumentDB/databaseAccounts/cosmosd5q1iefd/sqlRoleDefinitions/00000000-0000-0000-0000-000000000001"
  to = azurerm_cosmosdb_sql_role_definition.res-8
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-657bd609e27aba5f/providers/Microsoft.DocumentDB/databaseAccounts/cosmosd5q1iefd/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  to = azurerm_cosmosdb_sql_role_definition.res-9
}
