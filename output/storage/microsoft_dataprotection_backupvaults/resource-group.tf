terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "4.66.0"
    }
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "res-0" {
  location   = "westeurope"
  managed_by = ""
  name       = "rg-ardl-2b3276b507429af5"
  tags = {
    armType    = "Microsoft.DataProtection/backupVaults"
    createdUtc = "2026-07-15T19:22:16.1963236Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_data_protection_backup_vault" "res-1" {
  cross_region_restore_enabled = false
  datastore_type               = "VaultStore"
  immutability                 = "Disabled"
  location                     = "westeurope"
  name                         = "bvaulths4wux85"
  redundancy                   = "LocallyRedundant"
  resource_group_name          = azurerm_resource_group.res-0.name
  retention_duration_in_days   = 14
  soft_delete                  = "On"
  tags                         = {}
  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2b3276b507429af5"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2b3276b507429af5/providers/Microsoft.DataProtection/backupVaults/bvaulths4wux85"
  to = azurerm_data_protection_backup_vault.res-1
}
