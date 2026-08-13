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
  name       = "rg-ardl-3786f3c2c1905852"
  tags = {
    armType    = "Microsoft.DataProtection/resourceGuards"
    createdUtc = "2026-08-13T13:26:39.6169247Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_data_protection_resource_guard" "res-1" {
  location                                = "norwayeast"
  name                                    = "guardd9o3-acn"
  resource_group_name                     = azurerm_resource_group.res-0.name
  tags                                    = {}
  vault_critical_operation_exclusion_list = []
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3786f3c2c1905852"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3786f3c2c1905852/providers/Microsoft.DataProtection/resourceGuards/guardd9o3-acn"
  to = azurerm_data_protection_resource_guard.res-1
}
