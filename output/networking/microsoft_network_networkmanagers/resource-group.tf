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
  name       = "rg-ardl-e7c715ef90888af7"
  tags = {
    armType    = "Microsoft.Network/networkManagers"
    createdUtc = "2026-07-15T19:26:09.7773210Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_network_manager" "res-1" {
  description         = ""
  location            = "westeurope"
  name                = "vnmpd-y3wzq"
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
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-e7c715ef90888af7/providers/Microsoft.Network/networkManagers/vnmpd-y3wzq"
  to = azurerm_network_manager.res-1
}
