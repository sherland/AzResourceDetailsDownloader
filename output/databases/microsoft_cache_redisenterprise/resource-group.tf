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
  name       = "rg-ardl-17e0c65542ffc7e9"
  tags = {
    armType    = "Microsoft.Cache/redisEnterprise"
    createdUtc = "2026-08-16T13:17:25.8327604Z"
    purpose    = "az-resource-details-downloader"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-17e0c65542ffc7e9"
  to = azurerm_resource_group.res-0
}
