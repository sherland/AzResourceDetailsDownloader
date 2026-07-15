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
  name       = "rg-ardl-b0d3d468c211b31a"
  tags = {
    armType    = "Microsoft.Batch/batchAccounts"
    createdUtc = "2026-07-15T19:19:45.6376058Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_batch_account" "res-1" {
  allowed_authentication_modes        = ["AAD", "SharedKey", "TaskAuthenticationToken"]
  encryption                          = []
  location                            = "westeurope"
  name                                = "batchp09vx5pt"
  pool_allocation_mode                = "BatchService"
  primary_access_key                  = "" # Masked sensitive attribute
  public_network_access_enabled       = true
  resource_group_name                 = azurerm_resource_group.res-0.name
  secondary_access_key                = "" # Masked sensitive attribute
  storage_account_authentication_mode = ""
  storage_account_id                  = ""
  tags                                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b0d3d468c211b31a"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b0d3d468c211b31a/providers/Microsoft.Batch/batchAccounts/batchp09vx5pt"
  to = azurerm_batch_account.res-1
}
