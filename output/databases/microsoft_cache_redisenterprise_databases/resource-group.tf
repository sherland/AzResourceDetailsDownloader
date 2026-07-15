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
  name       = "rg-ardl-b793c055bdb1ae6b"
  tags = {
    armType    = "Microsoft.Cache/redisEnterprise/databases"
    createdUtc = "2026-07-15T09:00:52.0804262Z"
    purpose    = "az-resource-details-downloader"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b793c055bdb1ae6b"
  to = azurerm_resource_group.res-0
}
