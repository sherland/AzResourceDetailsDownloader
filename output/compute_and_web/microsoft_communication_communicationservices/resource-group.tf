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
  name       = "rg-ardl-03b31e1fc10f5155"
  tags = {
    armType    = "Microsoft.Communication/communicationServices"
    createdUtc = "2026-07-15T09:29:31.2350980Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_communication_service" "res-1" {
  data_location               = "Europe"
  name                        = "acso-awg-qq"
  primary_connection_string   = "" # Masked sensitive attribute
  primary_key                 = "" # Masked sensitive attribute
  resource_group_name         = azurerm_resource_group.res-0.name
  secondary_connection_string = "" # Masked sensitive attribute
  secondary_key               = "" # Masked sensitive attribute
  tags                        = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-03b31e1fc10f5155"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-03b31e1fc10f5155/providers/Microsoft.Communication/communicationServices/acso-awg-qq"
  to = azurerm_communication_service.res-1
}
