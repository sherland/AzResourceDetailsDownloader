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
  name       = "rg-ardl-c2f89a44d5a009de"
  tags = {
    armType    = "Microsoft.DataProtection/backupVaults/backupPolicies"
    createdUtc = "2026-08-16T14:35:53.7598130Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_data_protection_backup_vault" "res-1" {
  cross_region_restore_enabled = false
  datastore_type               = "VaultStore"
  immutability                 = "Disabled"
  location                     = "norwayeast"
  name                         = "bvaultoviytzop"
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
resource "azurerm_data_protection_backup_policy_blob_storage" "res-2" {
  backup_repeating_time_intervals        = []
  name                                   = "policyb8-t-9"
  operational_default_retention_duration = "P7D"
  time_zone                              = ""
  vault_default_retention_duration       = ""
  vault_id                               = azurerm_data_protection_backup_vault.res-1.id
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c2f89a44d5a009de"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c2f89a44d5a009de/providers/Microsoft.DataProtection/backupVaults/bvaultoviytzop"
  to = azurerm_data_protection_backup_vault.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c2f89a44d5a009de/providers/Microsoft.DataProtection/backupVaults/bvaultoviytzop/backupPolicies/policyb8-t-9"
  to = azurerm_data_protection_backup_policy_blob_storage.res-2
}
