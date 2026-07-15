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
  name       = "rg-ardl-c264a49334b4408f"
  tags = {
    armType    = "Microsoft.StorageSync/storageSyncServices"
    createdUtc = "2026-07-15T19:22:26.2361572Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_storage_sync" "res-1" {
  incoming_traffic_policy = "AllowAllTraffic"
  location                = "westeurope"
  name                    = "sssir56p9bl"
  resource_group_name     = azurerm_resource_group.res-0.name
  tags                    = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c264a49334b4408f"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c264a49334b4408f/providers/Microsoft.StorageSync/storageSyncServices/sssir56p9bl"
  to = azurerm_storage_sync.res-1
}
