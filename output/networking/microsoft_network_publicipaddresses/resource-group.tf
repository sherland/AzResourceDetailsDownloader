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
  name       = "rg-ardl-81fcf0828790336e"
  tags = {
    armType    = "Microsoft.Network/publicIPAddresses"
    createdUtc = "2026-08-16T13:13:48.2754573Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_public_ip" "res-1" {
  allocation_method       = "Static"
  ddos_protection_mode    = "VirtualNetworkInherited"
  domain_name_label       = ""
  domain_name_label_scope = ""
  edge_zone               = ""
  idle_timeout_in_minutes = 4
  ip_tags                 = {}
  ip_version              = "IPv4"
  location                = "norwayeast"
  name                    = "pip208b-5n5"
  resource_group_name     = azurerm_resource_group.res-0.name
  reverse_fqdn            = ""
  sku                     = "Standard"
  sku_tier                = "Regional"
  tags                    = {}
  zones                   = []
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-81fcf0828790336e"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-81fcf0828790336e/providers/Microsoft.Network/publicIPAddresses/pip208b-5n5"
  to = azurerm_public_ip.res-1
}
