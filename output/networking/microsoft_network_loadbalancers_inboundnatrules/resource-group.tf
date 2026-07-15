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
  name       = "rg-ardl-f39f3facaeacfc79"
  tags = {
    armType    = "Microsoft.Network/loadBalancers/inboundNatRules"
    createdUtc = "2026-07-15T19:13:28.4782469Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_lb" "res-1" {
  edge_zone           = ""
  location            = "westeurope"
  name                = "lbumojaw4n"
  resource_group_name = azurerm_resource_group.res-0.name
  sku                 = "Standard"
  sku_tier            = "Regional"
  tags                = {}
  frontend_ip_configuration {
    gateway_load_balancer_frontend_ip_configuration_id = ""
    name                                               = "feConfig"
    private_ip_address                                 = ""
    private_ip_address_allocation                      = "Dynamic"
    private_ip_address_version                         = ""
    public_ip_address_id                               = azurerm_public_ip.res-3.id
    public_ip_prefix_id                                = ""
    subnet_id                                          = ""
    zones                                              = []
  }
}
resource "azurerm_lb_nat_rule" "res-2" {
  backend_port                   = 22
  enable_floating_ip             = false
  enable_tcp_reset               = false
  floating_ip_enabled            = false
  frontend_ip_configuration_name = "feConfig"
  frontend_port                  = 5000
  frontend_port_end              = 0
  frontend_port_start            = 0
  idle_timeout_in_minutes        = 4
  loadbalancer_id                = azurerm_lb.res-1.id
  name                           = "natrulewegbj7"
  protocol                       = "Tcp"
  resource_group_name            = azurerm_resource_group.res-0.name
  tcp_reset_enabled              = false
}
resource "azurerm_public_ip" "res-3" {
  allocation_method       = "Static"
  ddos_protection_mode    = "VirtualNetworkInherited"
  edge_zone               = ""
  idle_timeout_in_minutes = 4
  ip_tags                 = {}
  ip_version              = "IPv4"
  location                = "westeurope"
  name                    = "pipw5v3-j40"
  resource_group_name     = azurerm_resource_group.res-0.name
  sku                     = "Standard"
  sku_tier                = "Regional"
  tags                    = {}
  zones                   = []
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-f39f3facaeacfc79"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-f39f3facaeacfc79/providers/Microsoft.Network/loadBalancers/lbumojaw4n"
  to = azurerm_lb.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-f39f3facaeacfc79/providers/Microsoft.Network/loadBalancers/lbumojaw4n/inboundNatRules/natrulewegbj7"
  to = azurerm_lb_nat_rule.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-f39f3facaeacfc79/providers/Microsoft.Network/publicIPAddresses/pipw5v3-j40"
  to = azurerm_public_ip.res-3
}
