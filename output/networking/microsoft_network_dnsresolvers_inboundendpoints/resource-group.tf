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
  name       = "rg-ardl-c4b711f9f1eb7a59"
  tags = {
    armType    = "Microsoft.Network/dnsResolvers/inboundEndpoints"
    createdUtc = "2026-08-13T13:32:35.0690935Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_private_dns_resolver" "res-1" {
  location            = "norwayeast"
  name                = "dnsrb-031p-1"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
  virtual_network_id  = azurerm_virtual_network.res-3.id
}
resource "azurerm_private_dns_resolver_inbound_endpoint" "res-2" {
  location                = "norwayeast"
  name                    = "inbound61hwdf"
  private_dns_resolver_id = azurerm_private_dns_resolver.res-1.id
  tags                    = {}
  ip_configurations {
    private_ip_address           = "10.62.0.4"
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.res-4.id
  }
}
resource "azurerm_virtual_network" "res-3" {
  address_space                  = ["10.62.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "norwayeast"
  name                           = "vnet3f-jfiwn"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet = [{
    address_prefixes                = ["10.62.0.0/28"]
    default_outbound_access_enabled = false
    delegation = [{
      name = "dnsResolverDelegation"
      service_delegation = [{
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        name    = "Microsoft.Network/dnsResolvers"
      }]
    }]
    id                                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c4b711f9f1eb7a59/providers/Microsoft.Network/virtualNetworks/vnet3f-jfiwn/subnets/inbound"
    name                                          = "inbound"
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
  address_prefixes                              = ["10.62.0.0/28"]
  default_outbound_access_enabled               = true
  name                                          = "inbound"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.res-0.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  sharing_scope                                 = ""
  virtual_network_name                          = "vnet3f-jfiwn"
  delegation {
    name = "dnsResolverDelegation"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
  depends_on = [
    azurerm_virtual_network.res-3,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c4b711f9f1eb7a59"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c4b711f9f1eb7a59/providers/Microsoft.Network/dnsResolvers/dnsrb-031p-1"
  to = azurerm_private_dns_resolver.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c4b711f9f1eb7a59/providers/Microsoft.Network/dnsResolvers/dnsrb-031p-1/inboundEndpoints/inbound61hwdf"
  to = azurerm_private_dns_resolver_inbound_endpoint.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c4b711f9f1eb7a59/providers/Microsoft.Network/virtualNetworks/vnet3f-jfiwn"
  to = azurerm_virtual_network.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c4b711f9f1eb7a59/providers/Microsoft.Network/virtualNetworks/vnet3f-jfiwn/subnets/inbound"
  to = azurerm_subnet.res-4
}
