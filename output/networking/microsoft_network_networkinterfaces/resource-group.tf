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
  name       = "rg-ardl-360f36f10d21782f"
  tags = {
    armType    = "Microsoft.Network/networkInterfaces"
    createdUtc = "2026-08-14T06:58:52.1220046Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_network_interface" "res-1" {
  accelerated_networking_enabled = false
  auxiliary_mode                 = ""
  auxiliary_sku                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  internal_dns_name_label        = ""
  ip_forwarding_enabled          = false
  location                       = "norwayeast"
  name                           = "nicoq4tq3cl"
  resource_group_name            = azurerm_resource_group.res-0.name
  tags                           = {}
  ip_configuration {
    gateway_load_balancer_frontend_ip_configuration_id = ""
    name                                               = "ipconfig1"
    primary                                            = true
    private_ip_address                                 = "10.41.0.4"
    private_ip_address_allocation                      = "Dynamic"
    private_ip_address_version                         = "IPv4"
    public_ip_address_id                               = ""
    subnet_id                                          = azurerm_subnet.res-3.id
  }
}
resource "azurerm_virtual_network" "res-2" {
  address_space                  = ["10.41.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "norwayeast"
  name                           = "vnetu-a-at4d"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet = [{
    address_prefixes                              = ["10.41.0.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-360f36f10d21782f/providers/Microsoft.Network/virtualNetworks/vnetu-a-at4d/subnets/default"
    name                                          = "default"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }]
  tags = {}
}
resource "azurerm_subnet" "res-3" {
  address_prefixes                              = ["10.41.0.0/24"]
  default_outbound_access_enabled               = true
  name                                          = "default"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.res-0.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  sharing_scope                                 = ""
  virtual_network_name                          = "vnetu-a-at4d"
  depends_on = [
    azurerm_virtual_network.res-2,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-360f36f10d21782f"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-360f36f10d21782f/providers/Microsoft.Network/networkInterfaces/nicoq4tq3cl"
  to = azurerm_network_interface.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-360f36f10d21782f/providers/Microsoft.Network/virtualNetworks/vnetu-a-at4d"
  to = azurerm_virtual_network.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-360f36f10d21782f/providers/Microsoft.Network/virtualNetworks/vnetu-a-at4d/subnets/default"
  to = azurerm_subnet.res-3
}
