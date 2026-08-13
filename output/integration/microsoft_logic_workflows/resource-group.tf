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
  name       = "rg-ardl-872102314c593a7d"
  tags = {
    armType    = "Microsoft.Logic/workflows"
    createdUtc = "2026-08-14T10:41:43.8962944Z"
    purpose    = "az-resource-details-downloader"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-872102314c593a7d"
  to = azurerm_resource_group.res-0
}
