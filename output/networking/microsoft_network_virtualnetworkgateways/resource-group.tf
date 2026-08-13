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
  name       = "rg-ardl-d410a1d9804bdd65"
  tags = {
    armType    = "Microsoft.Network/virtualNetworkGateways"
    createdUtc = "2026-08-13T12:45:37.4141885Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_public_ip" "res-1" {
  allocation_method       = "Static"
  ddos_protection_mode    = "VirtualNetworkInherited"
  domain_name_label       = ""
  domain_name_label_scope = ""
  edge_zone               = ""
  idle_timeout_in_minutes = 4
  ip_tags                 = {}
  ip_version              = "IPv4"
  location                = "norwayeast"
  name                    = "pipn1pda-f4"
  resource_group_name     = azurerm_resource_group.res-0.name
  reverse_fqdn            = ""
  sku                     = "Standard"
  sku_tier                = "Regional"
  tags                    = {}
  zones                   = ["1", "2", "3"]
}
resource "azurerm_virtual_network_gateway" "res-2" {
  active_active                         = false
  bgp_enabled                           = false
  bgp_route_translation_for_nat_enabled = false
  dns_forwarding_enabled                = false
  edge_zone                             = ""
  enable_bgp                            = false
  generation                            = "Generation1"
  ip_sec_replay_protection_enabled      = true
  location                              = "norwayeast"
  maximum_scale_unit                    = 0
  minimum_scale_unit                    = 0
  name                                  = "vgwhk9b25pp"
  private_ip_address_enabled            = false
  remote_vnet_traffic_enabled           = false
  resource_group_name                   = azurerm_resource_group.res-0.name
  sku                                   = "VpnGw1AZ"
  tags                                  = {}
  type                                  = "Vpn"
  virtual_wan_traffic_enabled           = false
  vpn_type                              = "RouteBased"
  bgp_settings {
    asn         = 65515
    peer_weight = 0
    peering_addresses {
      apipa_addresses       = []
      ip_configuration_name = "vnetGatewayConfig"
    }
  }
  ip_configuration {
    name                          = "vnetGatewayConfig"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.res-1.id
    subnet_id                     = azurerm_subnet.res-4.id
  }
}
resource "azurerm_virtual_network" "res-3" {
  address_space                  = ["10.20.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "norwayeast"
  name                           = "vnetj03y6p07"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet = [{
    address_prefixes                              = ["10.20.255.0/27"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d410a1d9804bdd65/providers/Microsoft.Network/virtualNetworks/vnetj03y6p07/subnets/GatewaySubnet"
    name                                          = "GatewaySubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }]
  tags = {}
}
resource "azurerm_subnet" "res-4" {
  address_prefixes                              = ["10.20.255.0/27"]
  default_outbound_access_enabled               = true
  name                                          = "GatewaySubnet"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.res-0.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  sharing_scope                                 = ""
  virtual_network_name                          = "vnetj03y6p07"
  depends_on = [
    azurerm_virtual_network.res-3,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d410a1d9804bdd65"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d410a1d9804bdd65/providers/Microsoft.Network/publicIPAddresses/pipn1pda-f4"
  to = azurerm_public_ip.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d410a1d9804bdd65/providers/Microsoft.Network/virtualNetworkGateways/vgwhk9b25pp"
  to = azurerm_virtual_network_gateway.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d410a1d9804bdd65/providers/Microsoft.Network/virtualNetworks/vnetj03y6p07"
  to = azurerm_virtual_network.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d410a1d9804bdd65/providers/Microsoft.Network/virtualNetworks/vnetj03y6p07/subnets/GatewaySubnet"
  to = azurerm_subnet.res-4
}
