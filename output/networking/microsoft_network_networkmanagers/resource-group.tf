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
  name       = "rg-ardl-e7c715ef90888af7"
  tags = {
    armType    = "Microsoft.Network/networkManagers"
    createdUtc = "2026-08-14T10:51:47.2453375Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_network_manager" "res-1" {
  description         = ""
  location            = "norwayeast"
  name                = "vnme71-anf7"
  resource_group_name = azurerm_resource_group.res-0.name
  scope_accesses      = ["Connectivity", "SecurityAdmin"]
  tags                = {}
  scope {
    management_group_ids = []
    subscription_ids     = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-e7c715ef90888af7"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-e7c715ef90888af7/providers/Microsoft.Network/networkManagers/vnme71-anf7"
  to = azurerm_network_manager.res-1
}
