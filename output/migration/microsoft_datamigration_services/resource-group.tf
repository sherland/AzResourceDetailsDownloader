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
  name       = "rg-ardl-862cc1ebaeeac2bb"
  tags = {
    armType    = "Microsoft.DataMigration/services"
    createdUtc = "2026-08-16T14:56:43.4205242Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_database_migration_service" "res-1" {
  location            = "norwayeast"
  name                = "dmsc4-b4-nf"
  resource_group_name = azurerm_resource_group.res-0.name
  sku_name            = "Premium_4vCores"
  subnet_id           = azurerm_subnet.res-4.id
  tags                = {}
}
resource "azurerm_network_interface" "res-2" {
  accelerated_networking_enabled = true
  auxiliary_mode                 = ""
  auxiliary_sku                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  internal_dns_name_label        = ""
  ip_forwarding_enabled          = false
  location                       = "norwayeast"
  name                           = "NIC-vznhg9v47dgbhh7vcjxyjmrf"
  resource_group_name            = azurerm_resource_group.res-0.name
  tags = {
    ServiceResourceId = azurerm_database_migration_service.res-1.id
  }
  ip_configuration {
    gateway_load_balancer_frontend_ip_configuration_id = ""
    name                                               = "ipconfig"
    primary                                            = true
    private_ip_address                                 = "10.81.0.4"
    private_ip_address_allocation                      = "Dynamic"
    private_ip_address_version                         = "IPv4"
    public_ip_address_id                               = ""
    subnet_id                                          = azurerm_subnet.res-4.id
  }
}
resource "azurerm_virtual_network" "res-3" {
  address_space                  = ["10.81.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "norwayeast"
  name                           = "vnet46-vasrl"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet = [{
    address_prefixes                              = ["10.81.0.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-862cc1ebaeeac2bb/providers/Microsoft.Network/virtualNetworks/vnet46-vasrl/subnets/default"
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
resource "azurerm_subnet" "res-4" {
  address_prefixes                              = ["10.81.0.0/24"]
  default_outbound_access_enabled               = true
  name                                          = "default"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.res-0.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  sharing_scope                                 = ""
  virtual_network_name                          = "vnet46-vasrl"
  depends_on = [
    azurerm_virtual_network.res-3,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-862cc1ebaeeac2bb"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-862cc1ebaeeac2bb/providers/Microsoft.DataMigration/services/dmsc4-b4-nf"
  to = azurerm_database_migration_service.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-862cc1ebaeeac2bb/providers/Microsoft.Network/networkInterfaces/NIC-vznhg9v47dgbhh7vcjxyjmrf"
  to = azurerm_network_interface.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-862cc1ebaeeac2bb/providers/Microsoft.Network/virtualNetworks/vnet46-vasrl"
  to = azurerm_virtual_network.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-862cc1ebaeeac2bb/providers/Microsoft.Network/virtualNetworks/vnet46-vasrl/subnets/default"
  to = azurerm_subnet.res-4
}
