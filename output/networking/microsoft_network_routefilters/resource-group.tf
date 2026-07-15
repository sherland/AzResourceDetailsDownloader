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
  name       = "rg-ardl-d924d0c6078bf7ed"
  tags = {
    armType    = "Microsoft.Network/routeFilters"
    createdUtc = "2026-07-15T19:25:09.4634071Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_route_filter" "res-1" {
  location            = "westeurope"
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
