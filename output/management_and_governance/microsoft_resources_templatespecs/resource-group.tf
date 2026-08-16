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
  name       = "rg-ardl-fdb1d833d4fb0cbd"
  tags = {
    armType    = "Microsoft.Resources/templateSpecs"
    createdUtc = "2026-08-16T13:46:25.3419458Z"
    purpose    = "az-resource-details-downloader"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-fdb1d833d4fb0cbd"
  to = azurerm_resource_group.res-0
}
