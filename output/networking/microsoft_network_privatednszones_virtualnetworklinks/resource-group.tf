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
  name       = "rg-ardl-75df539555d183d9"
  tags = {
    armType    = "Microsoft.Network/privateDnsZones/virtualNetworkLinks"
    createdUtc = "2026-08-14T10:40:04.1768718Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_private_dns_zone" "res-1" {
  name                = "ardlaksrdys9.private.contoso.com"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
  soa_record {
    email        = "azureprivatedns-host.microsoft.com"
    expire_time  = 2419200
    minimum_ttl  = 10
    refresh_time = 3600
    retry_time   = 300
    tags         = {}
    ttl          = 3600
  }
}
resource "azurerm_private_dns_zone_virtual_network_link" "res-3" {
  name                  = "linkwq5sky"
  private_dns_zone_name = "ardlaksrdys9.private.contoso.com"
  registration_enabled  = false
  resolution_policy     = ""
  resource_group_name   = azurerm_resource_group.res-0.name
  tags                  = {}
  virtual_network_id    = azurerm_virtual_network.res-4.id
  depends_on = [
    azurerm_private_dns_zone.res-1,
  ]
}
resource "azurerm_virtual_network" "res-4" {
  address_space                  = ["10.43.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "norwayeast"
  name                           = "vnet0643rlhc"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet                         = []
  tags                           = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-75df539555d183d9"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-75df539555d183d9/providers/Microsoft.Network/privateDnsZones/ardlaksrdys9.private.contoso.com"
  to = azurerm_private_dns_zone.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-75df539555d183d9/providers/Microsoft.Network/privateDnsZones/ardlaksrdys9.private.contoso.com/virtualNetworkLinks/linkwq5sky"
  to = azurerm_private_dns_zone_virtual_network_link.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-75df539555d183d9/providers/Microsoft.Network/virtualNetworks/vnet0643rlhc"
  to = azurerm_virtual_network.res-4
}
