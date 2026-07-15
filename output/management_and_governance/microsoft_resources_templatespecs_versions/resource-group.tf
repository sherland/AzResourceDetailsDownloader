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
  name       = "rg-ardl-4965fec5d0d82612"
  tags = {
    armType    = "Microsoft.Resources/templateSpecs/versions"
    createdUtc = "2026-07-15T09:27:00.6589942Z"
    purpose    = "az-resource-details-downloader"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-4965fec5d0d82612"
  to = azurerm_resource_group.res-0
}
