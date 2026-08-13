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
  name       = "rg-ardl-958b9ff2a7840139"
  tags = {
    armType    = "Microsoft.Network/virtualNetworks/virtualNetworkPeerings"
    createdUtc = "2026-08-13T13:20:42.5597309Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_virtual_network" "res-1" {
  address_space                  = ["10.90.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "norwayeast"
  name                           = "vnet5nvk-1-n"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet                         = []
  tags                           = {}
}
resource "azurerm_virtual_network_peering" "res-2" {
  allow_forwarded_traffic                = false
  allow_gateway_transit                  = false
  allow_virtual_network_access           = true
  local_subnet_names                     = []
  name                                   = "peer-to-b"
  only_ipv6_peering_enabled              = false
  peer_complete_virtual_networks_enabled = true
  remote_subnet_names                    = []
  remote_virtual_network_id              = azurerm_virtual_network.res-3.id
  resource_group_name                    = azurerm_resource_group.res-0.name
  use_remote_gateways                    = false
  virtual_network_name                   = "vnet5nvk-1-n"
  depends_on = [
    azurerm_virtual_network.res-1,
  ]
}
resource "azurerm_virtual_network" "res-3" {
  address_space                  = ["10.91.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "norwayeast"
  name                           = "vneteeas9wos"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet                         = []
  tags                           = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-958b9ff2a7840139"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-958b9ff2a7840139/providers/Microsoft.Network/virtualNetworks/vnet5nvk-1-n"
  to = azurerm_virtual_network.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-958b9ff2a7840139/providers/Microsoft.Network/virtualNetworks/vnet5nvk-1-n/virtualNetworkPeerings/peer-to-b"
  to = azurerm_virtual_network_peering.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-958b9ff2a7840139/providers/Microsoft.Network/virtualNetworks/vneteeas9wos"
  to = azurerm_virtual_network.res-3
}
