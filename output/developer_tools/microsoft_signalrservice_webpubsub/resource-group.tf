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
  name       = "rg-ardl-91e7d15b849117c3"
  tags = {
    armType    = "Microsoft.SignalRService/webPubSub"
    createdUtc = "2026-08-14T10:45:40.5178835Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_web_pubsub" "res-1" {
  aad_auth_enabled              = true
  capacity                      = 1
  local_auth_enabled            = true
  location                      = "norwayeast"
  name                          = "wpsjg-1-pq7"
  public_network_access_enabled = true
  resource_group_name           = azurerm_resource_group.res-0.name
  sku                           = "Free_F1"
  tags                          = {}
  tls_client_cert_enabled       = false
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-91e7d15b849117c3"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-91e7d15b849117c3/providers/Microsoft.SignalRService/webPubSub/wpsjg-1-pq7"
  to = azurerm_web_pubsub.res-1
}
