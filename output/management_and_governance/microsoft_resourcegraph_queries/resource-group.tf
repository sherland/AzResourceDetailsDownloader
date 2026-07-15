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
  name       = "rg-ardl-20c884988ac25a0c"
  tags = {
    armType    = "Microsoft.ResourceGraph/queries"
    createdUtc = "2026-07-15T11:12:59.6458266Z"
    purpose    = "az-resource-details-downloader"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-20c884988ac25a0c"
  to = azurerm_resource_group.res-0
}
