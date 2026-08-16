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
  name       = "rg-ardl-8d621c7a6b0df561"
  tags = {
    armType    = "Microsoft.Maps/accounts"
    createdUtc = "2026-08-16T14:21:05.1592080Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_maps_account" "res-1" {
  local_authentication_enabled = true
  location                     = "global"
  name                         = "mapsd-2raxh4"
  resource_group_name          = azurerm_resource_group.res-0.name
  sku_name                     = "G2"
  tags                         = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-8d621c7a6b0df561"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-8d621c7a6b0df561/providers/Microsoft.Maps/accounts/mapsd-2raxh4"
  to = azurerm_maps_account.res-1
}
