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
  name       = "rg-ardl-ac2c66a7d1df5255"
  tags = {
    armType    = "Microsoft.Network/natGateways"
    createdUtc = "2026-08-16T13:36:09.1535669Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_nat_gateway" "res-1" {
  idle_timeout_in_minutes = 4
  location                = "norwayeast"
  name                    = "natatj1p-oe"
  resource_group_name     = azurerm_resource_group.res-0.name
  sku_name                = "Standard"
  tags                    = {}
  zones                   = []
}
resource "azurerm_nat_gateway_public_ip_association" "res-2" {
  nat_gateway_id       = azurerm_nat_gateway.res-1.id
  public_ip_address_id = azurerm_public_ip.res-3.id
}
resource "azurerm_public_ip" "res-3" {
  allocation_method       = "Static"
  ddos_protection_mode    = "VirtualNetworkInherited"
  domain_name_label       = ""
  domain_name_label_scope = ""
  edge_zone               = ""
  idle_timeout_in_minutes = 4
  ip_tags                 = {}
  ip_version              = "IPv4"
  location                = "norwayeast"
  name                    = "pipx9-c-rky"
  resource_group_name     = azurerm_resource_group.res-0.name
  reverse_fqdn            = ""
  sku                     = "Standard"
  sku_tier                = "Regional"
  tags                    = {}
  zones                   = []
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-ac2c66a7d1df5255"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-ac2c66a7d1df5255/providers/Microsoft.Network/natGateways/natatj1p-oe"
  to = azurerm_nat_gateway.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-ac2c66a7d1df5255/providers/Microsoft.Network/natGateways/natatj1p-oe|/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-ac2c66a7d1df5255/providers/Microsoft.Network/publicIPAddresses/pipx9-c-rky"
  to = azurerm_nat_gateway_public_ip_association.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-ac2c66a7d1df5255/providers/Microsoft.Network/publicIPAddresses/pipx9-c-rky"
  to = azurerm_public_ip.res-3
}
