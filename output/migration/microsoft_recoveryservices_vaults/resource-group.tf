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
  name       = "rg-ardl-7f83b649b73888fd"
  tags = {
    armType    = "Microsoft.RecoveryServices/vaults"
    createdUtc = "2026-08-16T14:01:36.1382308Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_recovery_services_vault" "res-1" {
  classic_vmware_replication_enabled = false
  cross_region_restore_enabled       = false
  immutability                       = "Disabled"
  location                           = "norwayeast"
  name                               = "rsvb07c4h-s"
  public_network_access_enabled      = true
  resource_group_name                = azurerm_resource_group.res-0.name
  sku                                = "Standard"
  soft_delete_enabled                = true
  storage_mode_type                  = "GeoRedundant"
  tags                               = {}
}
resource "azurerm_backup_policy_vm" "res-2" {
  consistency_type               = ""
  instant_restore_retention_days = 2
  name                           = "DefaultPolicy"
  policy_type                    = "V1"
  recovery_vault_name            = "rsvb07c4h-s"
  resource_group_name            = azurerm_resource_group.res-0.name
  timezone                       = "UTC"
  backup {
    frequency     = "Daily"
    hour_duration = 0
    hour_interval = 0
    time          = "00:00"
    weekdays      = []
  }
  retention_daily {
    count = 30
  }
  depends_on = [
    azurerm_recovery_services_vault.res-1,
  ]
}
resource "azurerm_backup_policy_vm" "res-3" {
  consistency_type               = ""
  instant_restore_retention_days = 2
  name                           = "EnhancedPolicy"
  policy_type                    = "V2"
  recovery_vault_name            = "rsvb07c4h-s"
  resource_group_name            = azurerm_resource_group.res-0.name
  timezone                       = "UTC"
  backup {
    frequency     = "Hourly"
    hour_duration = 12
    hour_interval = 4
    time          = "08:00"
    weekdays      = []
  }
  retention_daily {
    count = 30
  }
  depends_on = [
    azurerm_recovery_services_vault.res-1,
  ]
}
resource "azurerm_backup_policy_vm_workload" "res-4" {
  name                = "HourlyLogBackup"
  recovery_vault_name = "rsvb07c4h-s"
  resource_group_name = azurerm_resource_group.res-0.name
  workload_type       = "SQLDataBase"
  protection_policy {
    policy_type = "Log"
    backup {
      frequency            = ""
      frequency_in_minutes = 60
      time                 = ""
      weekdays             = []
    }
    simple_retention {
      count = 30
    }
  }
  protection_policy {
    policy_type = "Full"
    backup {
      frequency            = "Daily"
      frequency_in_minutes = 0
      time                 = "00:00"
      weekdays             = []
    }
    retention_daily {
      count = 30
    }
  }
  settings {
    compression_enabled = false
    time_zone           = "UTC"
  }
  depends_on = [
    azurerm_recovery_services_vault.res-1,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7f83b649b73888fd"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7f83b649b73888fd/providers/Microsoft.RecoveryServices/vaults/rsvb07c4h-s"
  to = azurerm_recovery_services_vault.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7f83b649b73888fd/providers/Microsoft.RecoveryServices/vaults/rsvb07c4h-s/backupPolicies/DefaultPolicy"
  to = azurerm_backup_policy_vm.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7f83b649b73888fd/providers/Microsoft.RecoveryServices/vaults/rsvb07c4h-s/backupPolicies/EnhancedPolicy"
  to = azurerm_backup_policy_vm.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7f83b649b73888fd/providers/Microsoft.RecoveryServices/vaults/rsvb07c4h-s/backupPolicies/HourlyLogBackup"
  to = azurerm_backup_policy_vm_workload.res-4
}
