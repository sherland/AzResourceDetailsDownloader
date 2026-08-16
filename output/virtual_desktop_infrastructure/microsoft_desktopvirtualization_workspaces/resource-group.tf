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
  name       = "rg-ardl-19d479b8c5681686"
  tags = {
    armType    = "Microsoft.DesktopVirtualization/workspaces"
    createdUtc = "2026-08-16T13:43:35.2971797Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_virtual_desktop_workspace" "res-1" {
  description                   = ""
  friendly_name                 = ""
  location                      = "northeurope"
  name                          = "avdwsut7n7sj2"
  public_network_access_enabled = true
  resource_group_name           = azurerm_resource_group.res-0.name
  tags                          = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-19d479b8c5681686"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-19d479b8c5681686/providers/Microsoft.DesktopVirtualization/workspaces/avdwsut7n7sj2"
  to = azurerm_virtual_desktop_workspace.res-1
}
