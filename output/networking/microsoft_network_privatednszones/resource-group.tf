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
  name       = "rg-ardl-2686e82d1da8f0fc"
  tags = {
    armType    = "Microsoft.Network/privateDnsZones"
    createdUtc = "2026-08-16T13:15:24.9269035Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_private_dns_zone" "res-1" {
  name                = "ardltaj3h0wd.private.contoso.com"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
  soa_record {
    email        = "azureprivatedns-host.microsoft.com"
    expire_time  = 2419200
    minimum_ttl  = 10
    refresh_time = 3600
    retry_time   = 300
    tags         = {}
    ttl          = 3600
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2686e82d1da8f0fc"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2686e82d1da8f0fc/providers/Microsoft.Network/privateDnsZones/ardltaj3h0wd.private.contoso.com"
  to = azurerm_private_dns_zone.res-1
}
