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
  name       = "rg-ardl-7babd697af7caa22"
  tags = {
    armType    = "Microsoft.Network/bastionHosts"
    createdUtc = "2026-07-15T09:42:01.2194034Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_bastion_host" "res-1" {
  copy_paste_enabled        = true
  file_copy_enabled         = false
  ip_connect_enabled        = false
  kerberos_enabled          = false
  location                  = "westeurope"
  name                      = "bastiont9y5-i"
  resource_group_name       = azurerm_resource_group.res-0.name
  scale_units               = 2
  session_recording_enabled = false
  shareable_link_enabled    = false
  sku                       = "Basic"
  tags                      = {}
  tunneling_enabled         = false
  virtual_network_id        = ""
  zones                     = []
  ip_configuration {
    name                 = "bastionIpConfig"
    public_ip_address_id = azurerm_public_ip.res-2.id
    subnet_id            = azurerm_subnet.res-4.id
  }
}
resource "azurerm_public_ip" "res-2" {
  allocation_method       = "Static"
  ddos_protection_mode    = "VirtualNetworkInherited"
  edge_zone               = ""
  idle_timeout_in_minutes = 4
  ip_tags                 = {}
  ip_version              = "IPv4"
  location                = "westeurope"
  name                    = "pipos-z0e42"
  resource_group_name     = azurerm_resource_group.res-0.name
  sku                     = "Standard"
  sku_tier                = "Regional"
  tags                    = {}
  zones                   = []
}
resource "azurerm_virtual_network" "res-3" {
  address_space                  = ["10.44.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "westeurope"
  name                           = "vnetdrf-xp-d"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet = [{
    address_prefixes                              = ["10.44.255.0/26"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7babd697af7caa22/providers/Microsoft.Network/virtualNetworks/vnetdrf-xp-d/subnets/AzureBastionSubnet"
    name                                          = "AzureBastionSubnet"
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
  address_prefixes                              = ["10.44.255.0/26"]
  default_outbound_access_enabled               = true
  name                                          = "AzureBastionSubnet"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.res-0.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  sharing_scope                                 = ""
  virtual_network_name                          = "vnetdrf-xp-d"
  depends_on = [
    azurerm_virtual_network.res-3,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7babd697af7caa22"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7babd697af7caa22/providers/Microsoft.Network/bastionHosts/bastiont9y5-i"
  to = azurerm_bastion_host.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7babd697af7caa22/providers/Microsoft.Network/publicIPAddresses/pipos-z0e42"
  to = azurerm_public_ip.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7babd697af7caa22/providers/Microsoft.Network/virtualNetworks/vnetdrf-xp-d"
  to = azurerm_virtual_network.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7babd697af7caa22/providers/Microsoft.Network/virtualNetworks/vnetdrf-xp-d/subnets/AzureBastionSubnet"
  to = azurerm_subnet.res-4
}
