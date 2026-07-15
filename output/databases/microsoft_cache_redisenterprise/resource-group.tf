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
  name       = "rg-ardl-17e0c65542ffc7e9"
  tags = {
    armType    = "Microsoft.Cache/redisEnterprise"
    createdUtc = "2026-07-15T09:00:33.6147590Z"
    purpose    = "az-resource-details-downloader"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-17e0c65542ffc7e9"
  to = azurerm_resource_group.res-0
}
