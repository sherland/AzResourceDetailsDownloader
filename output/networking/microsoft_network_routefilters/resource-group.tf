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
  name       = "rg-ardl-d924d0c6078bf7ed"
  tags = {
    armType    = "Microsoft.Network/routeFilters"
    createdUtc = "2026-08-16T14:43:57.6865977Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_route_filter" "res-1" {
  location            = "norwayeast"
  name                = "rfa-y-8x89"
  resource_group_name = azurerm_resource_group.res-0.name
  rule                = []
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d924d0c6078bf7ed"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d924d0c6078bf7ed/providers/Microsoft.Network/routeFilters/rfa-y-8x89"
  to = azurerm_route_filter.res-1
}
