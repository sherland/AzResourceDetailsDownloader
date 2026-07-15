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
  name       = "rg-ardl-91e7d15b849117c3"
  tags = {
    armType    = "Microsoft.SignalRService/webPubSub"
    createdUtc = "2026-07-15T19:16:44.7152945Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_web_pubsub" "res-1" {
  aad_auth_enabled              = true
  capacity                      = 1
  local_auth_enabled            = true
  location                      = "westeurope"
  name                          = "wpswbqd8-py"
  primary_access_key            = "" # Masked sensitive attribute
  primary_connection_string     = "" # Masked sensitive attribute
  public_network_access_enabled = true
  resource_group_name           = azurerm_resource_group.res-0.name
  secondary_access_key          = "" # Masked sensitive attribute
  secondary_connection_string   = "" # Masked sensitive attribute
  sku                           = "Free_F1"
  tags                          = {}
  tls_client_cert_enabled       = false
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-91e7d15b849117c3"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-91e7d15b849117c3/providers/Microsoft.SignalRService/webPubSub/wpswbqd8-py"
  to = azurerm_web_pubsub.res-1
}
