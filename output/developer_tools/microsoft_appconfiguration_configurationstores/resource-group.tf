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
  name       = "rg-ardl-833890ef5c1b6d5f"
  tags = {
    armType    = "Microsoft.AppConfiguration/configurationStores"
    createdUtc = "2026-07-15T09:15:51.4748912Z"
    purpose    = "az-resource-details-downloader"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-833890ef5c1b6d5f"
  to = azurerm_resource_group.res-0
}
