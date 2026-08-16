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
  name       = "rg-ardl-b793c055bdb1ae6b"
  tags = {
    armType    = "Microsoft.Cache/redisEnterprise/databases"
    createdUtc = "2026-08-16T13:18:51.1076209Z"
    purpose    = "az-resource-details-downloader"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b793c055bdb1ae6b"
  to = azurerm_resource_group.res-0
}
