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
  name       = "rg-ardl-d9119f4e0aa21cf8"
  tags = {
    armType    = "Microsoft.Network/virtualNetworks"
    createdUtc = "2026-08-14T10:28:00.7544367Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_virtual_network" "res-1" {
  address_space                  = ["10.10.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "norwayeast"
  name                           = "vnetrco-4lfv"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet                         = []
  tags                           = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d9119f4e0aa21cf8"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d9119f4e0aa21cf8/providers/Microsoft.Network/virtualNetworks/vnetrco-4lfv"
  to = azurerm_virtual_network.res-1
}
