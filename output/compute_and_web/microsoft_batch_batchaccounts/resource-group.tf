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
  name       = "rg-ardl-b0d3d468c211b31a"
  tags = {
    armType    = "Microsoft.Batch/batchAccounts"
    createdUtc = "2026-08-16T14:31:02.4755075Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_batch_account" "res-1" {
  allowed_authentication_modes        = ["AAD", "SharedKey", "TaskAuthenticationToken"]
  encryption                          = []
  location                            = "norwayeast"
  name                                = "batchp09vx5pt"
  pool_allocation_mode                = "BatchService"
  public_network_access_enabled       = true
  resource_group_name                 = azurerm_resource_group.res-0.name
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
