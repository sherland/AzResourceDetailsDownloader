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
  name       = "rg-ardl-77c0bcdddf92bb37"
  tags = {
    armType    = "Microsoft.Network/dnsForwardingRulesets"
    createdUtc = "2026-08-13T13:31:33.9304671Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "res-1" {
  location                                   = "norwayeast"
  name                                       = "dfrsd-86-jjd"
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.res-3.id]
  resource_group_name                        = azurerm_resource_group.res-0.name
  tags                                       = {}
}
resource "azurerm_private_dns_resolver" "res-2" {
  location            = "norwayeast"
  name                = "dnsrg5d-jfb6"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
  virtual_network_id  = azurerm_virtual_network.res-4.id
}
resource "azurerm_private_dns_resolver_outbound_endpoint" "res-3" {
  location                = "norwayeast"
  name                    = "outboundtnd-yz"
  private_dns_resolver_id = azurerm_private_dns_resolver.res-2.id
  subnet_id               = azurerm_subnet.res-5.id
  tags                    = {}
}
resource "azurerm_virtual_network" "res-4" {
  address_space                  = ["10.60.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "norwayeast"
  name                           = "vneterg7184q"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet = [{
    address_prefixes                = ["10.60.1.0/28"]
    default_outbound_access_enabled = false
    delegation = [{
      name = "dnsResolverDelegation"
      service_delegation = [{
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        name    = "Microsoft.Network/dnsResolvers"
      }]
    }]
    id                                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-77c0bcdddf92bb37/providers/Microsoft.Network/virtualNetworks/vneterg7184q/subnets/outbound"
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
resource "azurerm_subnet" "res-5" {
  address_prefixes                              = ["10.60.1.0/28"]
  default_outbound_access_enabled               = true
  name                                          = "outbound"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.res-0.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  sharing_scope                                 = ""
  virtual_network_name                          = "vneterg7184q"
  delegation {
    name = "dnsResolverDelegation"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
  depends_on = [
    azurerm_virtual_network.res-4,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-77c0bcdddf92bb37"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-77c0bcdddf92bb37/providers/Microsoft.Network/dnsForwardingRulesets/dfrsd-86-jjd"
  to = azurerm_private_dns_resolver_dns_forwarding_ruleset.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-77c0bcdddf92bb37/providers/Microsoft.Network/dnsResolvers/dnsrg5d-jfb6"
  to = azurerm_private_dns_resolver.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-77c0bcdddf92bb37/providers/Microsoft.Network/dnsResolvers/dnsrg5d-jfb6/outboundEndpoints/outboundtnd-yz"
  to = azurerm_private_dns_resolver_outbound_endpoint.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-77c0bcdddf92bb37/providers/Microsoft.Network/virtualNetworks/vneterg7184q"
  to = azurerm_virtual_network.res-4
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-77c0bcdddf92bb37/providers/Microsoft.Network/virtualNetworks/vneterg7184q/subnets/outbound"
  to = azurerm_subnet.res-5
}
