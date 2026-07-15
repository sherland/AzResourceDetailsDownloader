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
  name       = "rg-ardl-286cff30700da727"
  tags = {
    armType    = "Microsoft.Network/azureFirewalls"
    createdUtc = "2026-07-15T10:09:24.0653636Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_firewall" "res-1" {
  dns_proxy_enabled   = false
  dns_servers         = []
  firewall_policy_id  = ""
  location            = "westeurope"
  name                = "afwd5edfm"
  private_ip_ranges   = []
  resource_group_name = azurerm_resource_group.res-0.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Basic"
  tags                = {}
  threat_intel_mode   = "Alert"
  zones               = []
  ip_configuration {
    name                 = "afwIpConfig"
    public_ip_address_id = azurerm_public_ip.res-2.id
    subnet_id            = azurerm_subnet.res-6.id
  }
  management_ip_configuration {
    name                 = "afwMgmtIpConfig"
    public_ip_address_id = azurerm_public_ip.res-3.id
    subnet_id            = azurerm_subnet.res-5.id
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
  name                    = "piph5-e48-s"
  resource_group_name     = azurerm_resource_group.res-0.name
  sku                     = "Standard"
  sku_tier                = "Regional"
  tags                    = {}
  zones                   = []
}
resource "azurerm_public_ip" "res-3" {
  allocation_method       = "Static"
  ddos_protection_mode    = "VirtualNetworkInherited"
  edge_zone               = ""
  idle_timeout_in_minutes = 4
  ip_tags                 = {}
  ip_version              = "IPv4"
  location                = "westeurope"
  name                    = "pipunesj-jt"
  resource_group_name     = azurerm_resource_group.res-0.name
  sku                     = "Standard"
  sku_tier                = "Regional"
  tags                    = {}
  zones                   = []
}
resource "azurerm_virtual_network" "res-4" {
  address_space                  = ["10.45.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "westeurope"
  name                           = "vnetw4qxan-j"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet = [{
    address_prefixes                              = ["10.45.254.0/26"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-286cff30700da727/providers/Microsoft.Network/virtualNetworks/vnetw4qxan-j/subnets/AzureFirewallManagementSubnet"
    name                                          = "AzureFirewallManagementSubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
    }, {
    address_prefixes                              = ["10.45.255.0/26"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-286cff30700da727/providers/Microsoft.Network/virtualNetworks/vnetw4qxan-j/subnets/AzureFirewallSubnet"
    name                                          = "AzureFirewallSubnet"
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
  address_prefixes                              = ["10.45.254.0/26"]
  default_outbound_access_enabled               = true
  name                                          = "AzureFirewallManagementSubnet"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.res-0.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  sharing_scope                                 = ""
  virtual_network_name                          = "vnetw4qxan-j"
  depends_on = [
    azurerm_virtual_network.res-4,
  ]
}
resource "azurerm_subnet" "res-6" {
  address_prefixes                              = ["10.45.255.0/26"]
  default_outbound_access_enabled               = true
  name                                          = "AzureFirewallSubnet"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.res-0.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  sharing_scope                                 = ""
  virtual_network_name                          = "vnetw4qxan-j"
  depends_on = [
    azurerm_virtual_network.res-4,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-286cff30700da727"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-286cff30700da727/providers/Microsoft.Network/azureFirewalls/afwd5edfm"
  to = azurerm_firewall.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-286cff30700da727/providers/Microsoft.Network/publicIPAddresses/piph5-e48-s"
  to = azurerm_public_ip.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-286cff30700da727/providers/Microsoft.Network/publicIPAddresses/pipunesj-jt"
  to = azurerm_public_ip.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-286cff30700da727/providers/Microsoft.Network/virtualNetworks/vnetw4qxan-j"
  to = azurerm_virtual_network.res-4
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-286cff30700da727/providers/Microsoft.Network/virtualNetworks/vnetw4qxan-j/subnets/AzureFirewallManagementSubnet"
  to = azurerm_subnet.res-5
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-286cff30700da727/providers/Microsoft.Network/virtualNetworks/vnetw4qxan-j/subnets/AzureFirewallSubnet"
  to = azurerm_subnet.res-6
}
