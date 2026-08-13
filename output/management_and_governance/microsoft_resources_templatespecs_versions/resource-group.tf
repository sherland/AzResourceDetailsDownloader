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
  name       = "rg-ardl-4965fec5d0d82612"
  tags = {
    armType    = "Microsoft.Resources/templateSpecs/versions"
    createdUtc = "2026-08-13T12:57:20.5587430Z"
    purpose    = "az-resource-details-downloader"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-4965fec5d0d82612"
  to = azurerm_resource_group.res-0
}
