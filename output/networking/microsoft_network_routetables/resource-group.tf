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
  name       = "rg-ardl-a5f552c7b14230d8"
  tags = {
    armType    = "Microsoft.Network/routeTables"
    createdUtc = "2026-07-15T09:13:30.0085653Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_route_table" "res-1" {
  bgp_route_propagation_enabled = true
  location                      = "westeurope"
  name                          = "rt3nepn-8s"
  resource_group_name           = azurerm_resource_group.res-0.name
  route                         = []
  tags                          = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a5f552c7b14230d8"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a5f552c7b14230d8/providers/Microsoft.Network/routeTables/rt3nepn-8s"
  to = azurerm_route_table.res-1
}
