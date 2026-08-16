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
  name       = "rg-ardl-b3b443cef46c2376"
  tags = {
    armType    = "Microsoft.Network/routeTables/routes"
    createdUtc = "2026-08-16T14:16:22.7195412Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_route_table" "res-1" {
  bgp_route_propagation_enabled = true
  location                      = "norwayeast"
  name                          = "rtjowsda-7"
  resource_group_name           = azurerm_resource_group.res-0.name
  route = [{
    address_prefix         = "10.99.0.0/24"
    name                   = "routejzqqmb"
    next_hop_in_ip_address = "10.99.0.4"
    next_hop_type          = "VirtualAppliance"
  }]
  tags = {}
}
resource "azurerm_route" "res-2" {
  address_prefix         = "10.99.0.0/24"
  name                   = "routejzqqmb"
  next_hop_in_ip_address = "10.99.0.4"
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = azurerm_resource_group.res-0.name
  route_table_name       = "rtjowsda-7"
  depends_on = [
    azurerm_route_table.res-1,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b3b443cef46c2376"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b3b443cef46c2376/providers/Microsoft.Network/routeTables/rtjowsda-7"
  to = azurerm_route_table.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b3b443cef46c2376/providers/Microsoft.Network/routeTables/rtjowsda-7/routes/routejzqqmb"
  to = azurerm_route.res-2
}
