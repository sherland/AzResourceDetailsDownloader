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
  name       = "rg-ardl-8dd0677652d313d5"
  tags = {
    armType    = "Microsoft.DBforPostgreSQL/flexibleServers"
    createdUtc = "2026-08-14T12:29:02.8239006Z"
    purpose    = "az-resource-details-downloader"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-8dd0677652d313d5"
  to = azurerm_resource_group.res-0
}
