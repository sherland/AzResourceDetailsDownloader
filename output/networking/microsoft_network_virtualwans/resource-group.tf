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
  name       = "rg-ardl-7a9beee1f910a260"
  tags = {
    armType    = "Microsoft.Network/virtualWans"
    createdUtc = "2026-07-15T09:27:53.6945490Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_virtual_wan" "res-1" {
  allow_branch_to_branch_traffic    = true
  disable_vpn_encryption            = false
  location                          = "westeurope"
  name                              = "vwanln-0o-eh"
  office365_local_breakout_category = "None"
  resource_group_name               = azurerm_resource_group.res-0.name
  tags                              = {}
  type                              = "Standard"
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7a9beee1f910a260"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7a9beee1f910a260/providers/Microsoft.Network/virtualWans/vwanln-0o-eh"
  to = azurerm_virtual_wan.res-1
}
