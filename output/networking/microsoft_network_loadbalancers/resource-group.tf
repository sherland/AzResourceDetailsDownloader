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
  name       = "rg-ardl-a9a38ecf30bcae8b"
  tags = {
    armType    = "Microsoft.Network/loadBalancers"
    createdUtc = "2026-07-15T18:21:41.0632557Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_lb" "res-1" {
  edge_zone           = ""
  location            = "westeurope"
  name                = "lbi1py-djf"
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
    public_ip_address_id                               = azurerm_public_ip.res-2.id
    public_ip_prefix_id                                = ""
    subnet_id                                          = ""
    zones                                              = []
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
  name                    = "pip4esx-wt9"
  resource_group_name     = azurerm_resource_group.res-0.name
  sku                     = "Standard"
  sku_tier                = "Regional"
  tags                    = {}
  zones                   = []
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a9a38ecf30bcae8b"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a9a38ecf30bcae8b/providers/Microsoft.Network/loadBalancers/lbi1py-djf"
  to = azurerm_lb.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a9a38ecf30bcae8b/providers/Microsoft.Network/publicIPAddresses/pip4esx-wt9"
  to = azurerm_public_ip.res-2
}
