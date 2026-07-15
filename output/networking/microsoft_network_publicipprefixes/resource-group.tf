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
  name       = "rg-ardl-6dd711334648bb28"
  tags = {
    armType    = "Microsoft.Network/publicIPPrefixes"
    createdUtc = "2026-07-15T19:24:32.7550705Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_public_ip_prefix" "res-1" {
  custom_ip_prefix_id = ""
  ip_version          = "IPv4"
  location            = "westeurope"
  name                = "pippfxwtr6ge"
  prefix_length       = 28
  resource_group_name = azurerm_resource_group.res-0.name
  sku                 = "Standard"
  sku_tier            = "Regional"
  tags                = {}
  zones               = []
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-6dd711334648bb28"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-6dd711334648bb28/providers/Microsoft.Network/publicIPPrefixes/pippfxwtr6ge"
  to = azurerm_public_ip_prefix.res-1
}
