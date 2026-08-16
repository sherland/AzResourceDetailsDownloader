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
  name       = "rg-ardl-a3262f4eeb66a89e"
  tags = {
    armType    = "Microsoft.Network/privateLinkServices"
    createdUtc = "2026-08-16T14:49:05.5484614Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_lb" "res-1" {
  edge_zone           = ""
  location            = "norwayeast"
  name                = "lbv3r8rnuu"
  resource_group_name = azurerm_resource_group.res-0.name
  sku                 = "Standard"
  sku_tier            = "Regional"
  tags                = {}
  frontend_ip_configuration {
    gateway_load_balancer_frontend_ip_configuration_id = ""
    name                                               = "feConfig"
    private_ip_address                                 = "10.64.0.4"
    private_ip_address_allocation                      = "Dynamic"
    private_ip_address_version                         = "IPv4"
    public_ip_address_id                               = ""
    public_ip_prefix_id                                = ""
    subnet_id                                          = azurerm_subnet.res-5.id
    zones                                              = []
  }
}
resource "azurerm_network_interface" "res-2" {
  accelerated_networking_enabled = false
  auxiliary_mode                 = ""
  auxiliary_sku                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  internal_dns_name_label        = ""
  ip_forwarding_enabled          = false
  location                       = "norwayeast"
  name                           = "plsd0-7-olm.nic.14af038b-c51c-45d4-8d88-379c95678db3"
  resource_group_name            = azurerm_resource_group.res-0.name
  tags                           = {}
  ip_configuration {
    gateway_load_balancer_frontend_ip_configuration_id = ""
    name                                               = "plsipconfig"
    primary                                            = true
    private_ip_address                                 = "10.64.0.5"
    private_ip_address_allocation                      = "Dynamic"
    private_ip_address_version                         = "IPv4"
    public_ip_address_id                               = ""
    subnet_id                                          = azurerm_subnet.res-5.id
  }
}
resource "azurerm_private_link_service" "res-3" {
  auto_approval_subscription_ids              = []
  destination_ip_address                      = ""
  enable_proxy_protocol                       = false
  fqdns                                       = []
  load_balancer_frontend_ip_configuration_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a3262f4eeb66a89e/providers/Microsoft.Network/loadBalancers/lbv3r8rnuu/frontendIPConfigurations/feConfig"]
  location                                    = "norwayeast"
  name                                        = "plsd0-7-olm"
  proxy_protocol_enabled                      = false
  resource_group_name                         = azurerm_resource_group.res-0.name
  tags                                        = {}
  visibility_subscription_ids                 = []
  nat_ip_configuration {
    name                       = "plsipconfig"
    primary                    = true
    private_ip_address         = ""
    private_ip_address_version = "IPv4"
    subnet_id                  = azurerm_subnet.res-5.id
  }
}
resource "azurerm_virtual_network" "res-4" {
  address_space                  = ["10.64.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "norwayeast"
  name                           = "vnet3rh8yq8u"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet = [{
    address_prefixes                              = ["10.64.0.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a3262f4eeb66a89e/providers/Microsoft.Network/virtualNetworks/vnet3rh8yq8u/subnets/default"
    name                                          = "default"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = false
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }]
  tags = {}
}
resource "azurerm_subnet" "res-5" {
  address_prefixes                              = ["10.64.0.0/24"]
  default_outbound_access_enabled               = true
  name                                          = "default"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = false
  resource_group_name                           = azurerm_resource_group.res-0.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  sharing_scope                                 = ""
  virtual_network_name                          = "vnet3rh8yq8u"
  depends_on = [
    azurerm_virtual_network.res-4,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a3262f4eeb66a89e"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a3262f4eeb66a89e/providers/Microsoft.Network/loadBalancers/lbv3r8rnuu"
  to = azurerm_lb.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a3262f4eeb66a89e/providers/Microsoft.Network/networkInterfaces/plsd0-7-olm.nic.14af038b-c51c-45d4-8d88-379c95678db3"
  to = azurerm_network_interface.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a3262f4eeb66a89e/providers/Microsoft.Network/privateLinkServices/plsd0-7-olm"
  to = azurerm_private_link_service.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a3262f4eeb66a89e/providers/Microsoft.Network/virtualNetworks/vnet3rh8yq8u"
  to = azurerm_virtual_network.res-4
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a3262f4eeb66a89e/providers/Microsoft.Network/virtualNetworks/vnet3rh8yq8u/subnets/default"
  to = azurerm_subnet.res-5
}
