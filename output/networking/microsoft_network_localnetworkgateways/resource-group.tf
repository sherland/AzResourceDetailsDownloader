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
  name       = "rg-ardl-2b885a3134f70ff5"
  tags = {
    armType    = "Microsoft.Network/localNetworkGateways"
    createdUtc = "2026-07-15T18:36:23.0051744Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_local_network_gateway" "res-1" {
  address_space       = ["192.168.100.0/24"]
  gateway_address     = "203.0.113.1"
  gateway_fqdn        = ""
  location            = "westeurope"
  name                = "lngrd5p5kd4"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2b885a3134f70ff5"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2b885a3134f70ff5/providers/Microsoft.Network/localNetworkGateways/lngrd5p5kd4"
  to = azurerm_local_network_gateway.res-1
}
