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
  name       = "rg-ardl-25ff70224f326e0e"
  tags = {
    armType    = "Microsoft.Cdn/profiles"
    createdUtc = "2026-07-15T09:18:57.8081699Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_cdn_frontdoor_profile" "res-1" {
  name                     = "cdncz-d9z3m"
  resource_group_name      = azurerm_resource_group.res-0.name
  response_timeout_seconds = 30
  sku_name                 = "Standard_AzureFrontDoor"
  tags                     = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-25ff70224f326e0e"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-25ff70224f326e0e/providers/Microsoft.Cdn/profiles/cdncz-d9z3m"
  to = azurerm_cdn_frontdoor_profile.res-1
}
