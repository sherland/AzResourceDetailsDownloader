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
  name       = "rg-ardl-9ba774595fc4a14a"
  tags = {
    armType    = "Microsoft.Network/dnsResolvers/outboundEndpoints"
    createdUtc = "2026-08-13T13:33:04.9706970Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_private_dns_resolver" "res-1" {
  location            = "norwayeast"
  name                = "dnsrqragsytf"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
  virtual_network_id  = azurerm_virtual_network.res-3.id
}
resource "azurerm_private_dns_resolver_outbound_endpoint" "res-2" {
  location                = "norwayeast"
  name                    = "outboundngye8c"
  private_dns_resolver_id = azurerm_private_dns_resolver.res-1.id
  subnet_id               = azurerm_subnet.res-4.id
  tags                    = {}
}
resource "azurerm_virtual_network" "res-3" {
  address_space                  = ["10.63.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "norwayeast"
  name                           = "vnet5jlfehrw"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet = [{
    address_prefixes                = ["10.63.0.0/28"]
    default_outbound_access_enabled = false
    delegation = [{
      name = "dnsResolverDelegation"
      service_delegation = [{
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        name    = "Microsoft.Network/dnsResolvers"
      }]
    }]
    id                                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9ba774595fc4a14a/providers/Microsoft.Network/virtualNetworks/vnet5jlfehrw/subnets/outbound"
    name                                          = "outbound"
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
  address_prefixes                              = ["10.63.0.0/28"]
  default_outbound_access_enabled               = true
  name                                          = "outbound"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.res-0.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  sharing_scope                                 = ""
  virtual_network_name                          = "vnet5jlfehrw"
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
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9ba774595fc4a14a"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9ba774595fc4a14a/providers/Microsoft.Network/dnsResolvers/dnsrqragsytf"
  to = azurerm_private_dns_resolver.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9ba774595fc4a14a/providers/Microsoft.Network/dnsResolvers/dnsrqragsytf/outboundEndpoints/outboundngye8c"
  to = azurerm_private_dns_resolver_outbound_endpoint.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9ba774595fc4a14a/providers/Microsoft.Network/virtualNetworks/vnet5jlfehrw"
  to = azurerm_virtual_network.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9ba774595fc4a14a/providers/Microsoft.Network/virtualNetworks/vnet5jlfehrw/subnets/outbound"
  to = azurerm_subnet.res-4
}
