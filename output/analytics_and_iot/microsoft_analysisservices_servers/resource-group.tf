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
  name       = "rg-ardl-fbd354f185c6fa29"
  tags = {
    armType    = "Microsoft.AnalysisServices/servers"
    createdUtc = "2026-08-16T17:09:36.5247257Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_analysis_services_server" "res-1" {
  admin_users               = ["22222222-2222-2222-2222-222222222222"]
  backup_blob_container_uri = "" # Masked sensitive attribute
  location                  = "northeurope"
  name                      = "asrivqjljz"
  power_bi_service_enabled  = false
  querypool_connection_mode = "All"
  resource_group_name       = azurerm_resource_group.res-0.name
  sku                       = "D1"
  tags                      = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-fbd354f185c6fa29"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-fbd354f185c6fa29/providers/Microsoft.AnalysisServices/servers/asrivqjljz"
  to = azurerm_analysis_services_server.res-1
}
