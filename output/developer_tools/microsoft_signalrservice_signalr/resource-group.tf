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
  name       = "rg-ardl-d06e581e9c4c92a1"
  tags = {
    armType    = "Microsoft.SignalRService/signalR"
    createdUtc = "2026-08-13T14:35:11.0429923Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_signalr_service" "res-1" {
  aad_auth_enabled                         = true
  connectivity_logs_enabled                = false
  http_request_logs_enabled                = false
  live_trace_enabled                       = false
  local_auth_enabled                       = true
  location                                 = "norwayeast"
  messaging_logs_enabled                   = false
  name                                     = "sigr3beb-6nx"
  public_network_access_enabled            = true
  resource_group_name                      = azurerm_resource_group.res-0.name
  serverless_connection_timeout_in_seconds = 30
  service_mode                             = "Default"
  tags                                     = {}
  tls_client_cert_enabled                  = false
  cors {
    allowed_origins = ["*"]
  }
  sku {
    capacity = 1
    name     = "Free_F1"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d06e581e9c4c92a1"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d06e581e9c4c92a1/providers/Microsoft.SignalRService/signalR/sigr3beb-6nx"
  to = azurerm_signalr_service.res-1
}
