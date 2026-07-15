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
  name       = "rg-ardl-cfd84dd43feb6f85"
  tags = {
    armType    = "Microsoft.Network/dnsResolvers"
    createdUtc = "2026-07-15T19:26:40.9281699Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_private_dns_resolver" "res-1" {
  location            = "westeurope"
  name                = "dnsr1f3k6j-x"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
  virtual_network_id  = azurerm_virtual_network.res-2.id
}
resource "azurerm_virtual_network" "res-2" {
  address_space                  = ["10.61.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "westeurope"
  name                           = "vnetkh0jx-02"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet                         = []
  tags                           = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-cfd84dd43feb6f85"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-cfd84dd43feb6f85/providers/Microsoft.Network/dnsResolvers/dnsr1f3k6j-x"
  to = azurerm_private_dns_resolver.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-cfd84dd43feb6f85/providers/Microsoft.Network/virtualNetworks/vnetkh0jx-02"
  to = azurerm_virtual_network.res-2
}
