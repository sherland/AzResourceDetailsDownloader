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
  name       = "rg-ardl-d4acf6ea90680855"
  tags = {
    armType    = "Microsoft.Cdn/profiles/afdEndpoints"
    createdUtc = "2026-07-15T09:19:14.1020346Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_cdn_frontdoor_profile" "res-1" {
  name                     = "cdnm8-y-pfd"
  resource_group_name      = azurerm_resource_group.res-0.name
  response_timeout_seconds = 30
  sku_name                 = "Standard_AzureFrontDoor"
  tags                     = {}
}
resource "azurerm_cdn_frontdoor_endpoint" "res-2" {
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.res-1.id
  enabled                  = true
  name                     = "afdepl-85k0"
  tags                     = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d4acf6ea90680855"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d4acf6ea90680855/providers/Microsoft.Cdn/profiles/cdnm8-y-pfd"
  to = azurerm_cdn_frontdoor_profile.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d4acf6ea90680855/providers/Microsoft.Cdn/profiles/cdnm8-y-pfd/afdEndpoints/afdepl-85k0"
  to = azurerm_cdn_frontdoor_endpoint.res-2
}
