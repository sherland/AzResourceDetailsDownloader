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
  name       = "rg-ardl-83d5300c87a0f865"
  tags = {
    armType    = "Microsoft.Network/virtualNetworks/subnets"
    createdUtc = "2026-07-15T18:20:02.1979787Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_virtual_network" "res-1" {
  address_space                  = ["10.10.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "westeurope"
  name                           = "vnet93wy8s69"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet = [{
    address_prefixes                              = ["10.10.1.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-83d5300c87a0f865/providers/Microsoft.Network/virtualNetworks/vnet93wy8s69/subnets/subnetcua-vp"
    name                                          = "subnetcua-vp"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }]
  tags = {}
}
resource "azurerm_subnet" "res-2" {
  address_prefixes                              = ["10.10.1.0/24"]
  default_outbound_access_enabled               = true
  name                                          = "subnetcua-vp"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.res-0.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  sharing_scope                                 = ""
  virtual_network_name                          = "vnet93wy8s69"
  depends_on = [
    azurerm_virtual_network.res-1,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-83d5300c87a0f865"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-83d5300c87a0f865/providers/Microsoft.Network/virtualNetworks/vnet93wy8s69"
  to = azurerm_virtual_network.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-83d5300c87a0f865/providers/Microsoft.Network/virtualNetworks/vnet93wy8s69/subnets/subnetcua-vp"
  to = azurerm_subnet.res-2
}
