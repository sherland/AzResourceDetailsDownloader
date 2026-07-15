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
  location   = "westeurope"
  managed_by = ""
  name       = "rg-ardl-8ea2c4413f84d4d7"
  tags = {
    armType    = "Microsoft.Search/searchServices"
    createdUtc = "2026-07-15T18:48:08.1000925Z"
    purpose    = "az-resource-details-downloader"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-8ea2c4413f84d4d7"
  to = azurerm_resource_group.res-0
}
