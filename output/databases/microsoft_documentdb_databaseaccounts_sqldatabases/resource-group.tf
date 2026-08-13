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
  name       = "rg-ardl-5579991495fbf667"
  tags = {
    armType    = "Microsoft.DocumentDB/databaseAccounts/sqlDatabases"
    createdUtc = "2026-08-13T14:46:48.7284063Z"
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
  name                                  = "cosmoskhz1chh1"
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
resource "azurerm_cosmosdb_sql_database" "res-2" {
  account_name        = "cosmoskhz1chh1"
  name                = "sqldb"
  resource_group_name = azurerm_resource_group.res-0.name
  depends_on = [
    azurerm_cosmosdb_account.res-1,
  ]
}
resource "azurerm_cosmosdb_sql_role_definition" "res-9" {
  account_name        = "cosmoskhz1chh1"
  assignable_scopes   = [azurerm_cosmosdb_account.res-1.id]
  name                = "Cosmos DB Built-in Data Reader"
  resource_group_name = azurerm_resource_group.res-0.name
  role_definition_id  = "00000000-0000-0000-0000-000000000001"
  type                = "BuiltInRole"
  permissions {
    data_actions = ["Microsoft.DocumentDB/databaseAccounts/readMetadata", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/executeQuery", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/readChangeFeed"]
  }
}
resource "azurerm_cosmosdb_sql_role_definition" "res-10" {
  account_name        = "cosmoskhz1chh1"
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
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-5579991495fbf667"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-5579991495fbf667/providers/Microsoft.DocumentDB/databaseAccounts/cosmoskhz1chh1"
  to = azurerm_cosmosdb_account.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-5579991495fbf667/providers/Microsoft.DocumentDB/databaseAccounts/cosmoskhz1chh1/sqlDatabases/sqldb"
  to = azurerm_cosmosdb_sql_database.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-5579991495fbf667/providers/Microsoft.DocumentDB/databaseAccounts/cosmoskhz1chh1/sqlRoleDefinitions/00000000-0000-0000-0000-000000000001"
  to = azurerm_cosmosdb_sql_role_definition.res-9
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-5579991495fbf667/providers/Microsoft.DocumentDB/databaseAccounts/cosmoskhz1chh1/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  to = azurerm_cosmosdb_sql_role_definition.res-10
}
