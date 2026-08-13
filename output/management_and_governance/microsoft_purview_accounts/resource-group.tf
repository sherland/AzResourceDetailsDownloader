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
  name       = "rg-ardl-dc7f048c78a5aec9"
  tags = {
    armType    = "Microsoft.Purview/accounts"
    createdUtc = "2026-08-13T14:17:41.9413461Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_purview_account" "res-1" {
  location                    = "swedencentral"
  managed_event_hub_enabled   = false
  managed_resource_group_name = "ardl-purview-managed-rzaim-qz"
  name                        = "pviewxur-y95m"
  public_network_enabled      = true
  resource_group_name         = azurerm_resource_group.res-0.name
  tags                        = {}
  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-dc7f048c78a5aec9"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-dc7f048c78a5aec9/providers/Microsoft.Purview/accounts/pviewxur-y95m"
  to = azurerm_purview_account.res-1
}
