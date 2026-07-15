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
  name       = "rg-ardl-74933ead8c5e44f6"
  tags = {
    armType    = "Microsoft.Communication/emailServices"
    createdUtc = "2026-07-15T18:50:10.9996288Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_email_communication_service" "res-1" {
  data_location       = "Europe"
  name                = "acsemailgkz-9e-3"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-74933ead8c5e44f6"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-74933ead8c5e44f6/providers/Microsoft.Communication/emailServices/acsemailgkz-9e-3"
  to = azurerm_email_communication_service.res-1
}
