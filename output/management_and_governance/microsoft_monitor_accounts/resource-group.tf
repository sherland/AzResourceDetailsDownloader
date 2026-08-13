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
  name       = "rg-ardl-3255b6ea5eb259ce"
  tags = {
    armType    = "Microsoft.Monitor/accounts"
    createdUtc = "2026-08-13T12:55:22.1772708Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_monitor_workspace" "res-1" {
  location                      = "norwayeast"
  name                          = "amona-g-1-e5"
  public_network_access_enabled = true
  resource_group_name           = azurerm_resource_group.res-0.name
  tags                          = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3255b6ea5eb259ce"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3255b6ea5eb259ce/providers/Microsoft.Monitor/accounts/amona-g-1-e5"
  to = azurerm_monitor_workspace.res-1
}
