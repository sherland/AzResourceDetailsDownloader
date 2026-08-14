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
  name       = "rg-ardl-833890ef5c1b6d5f"
  tags = {
    armType    = "Microsoft.AppConfiguration/configurationStores"
    createdUtc = "2026-08-14T12:16:47.4460487Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_app_configuration" "res-1" {
  data_plane_proxy_authentication_mode             = "Local"
  data_plane_proxy_private_link_delegation_enabled = false
  local_auth_enabled                               = true
  location                                         = "norwayeast"
  name                                             = "appcskiph6ald"
  public_network_access                            = ""
  purge_protection_enabled                         = false
  resource_group_name                              = azurerm_resource_group.res-0.name
  sku                                              = "free"
  soft_delete_retention_days                       = 0
  tags                                             = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-833890ef5c1b6d5f"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-833890ef5c1b6d5f/providers/Microsoft.AppConfiguration/configurationStores/appcskiph6ald"
  to = azurerm_app_configuration.res-1
}
