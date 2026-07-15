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
  name       = "rg-ardl-a5c3f65f8513ba7b"
  tags = {
    armType    = "Microsoft.Insights/actionGroups"
    createdUtc = "2026-07-15T09:06:58.4887700Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_monitor_action_group" "res-1" {
  enabled             = true
  location            = "global"
  name                = "agnmvk1q9b"
  resource_group_name = azurerm_resource_group.res-0.name
  short_name          = "ardlag"
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a5c3f65f8513ba7b"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a5c3f65f8513ba7b/providers/Microsoft.Insights/actionGroups/agnmvk1q9b"
  to = azurerm_monitor_action_group.res-1
}
