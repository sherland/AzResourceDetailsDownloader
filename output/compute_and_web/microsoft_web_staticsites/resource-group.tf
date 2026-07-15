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
  name       = "rg-ardl-50afc5ec1d1fef44"
  tags = {
    armType    = "Microsoft.Web/staticSites"
    createdUtc = "2026-07-15T09:08:55.9615942Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_static_web_app" "res-1" {
  api_key                            = "" # Masked sensitive attribute
  app_settings                       = {}
  configuration_file_changes_enabled = true
  location                           = "westeurope"
  name                               = "stapp9n53-4-v"
  preview_environments_enabled       = true
  public_network_access_enabled      = true
  repository_branch                  = ""
  repository_token                   = "" # Masked sensitive attribute
  repository_url                     = ""
  resource_group_name                = azurerm_resource_group.res-0.name
  sku_size                           = "Free"
  sku_tier                           = "Free"
  tags                               = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-50afc5ec1d1fef44"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-50afc5ec1d1fef44/providers/Microsoft.Web/staticSites/stapp9n53-4-v"
  to = azurerm_static_web_app.res-1
}
