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
  name       = "rg-ardl-03b31e1fc10f5155"
  tags = {
    armType    = "Microsoft.Communication/communicationServices"
    createdUtc = "2026-08-14T10:36:32.4321264Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_communication_service" "res-1" {
  data_location       = "Europe"
  name                = "acs5mq89eka"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-03b31e1fc10f5155"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-03b31e1fc10f5155/providers/Microsoft.Communication/communicationServices/acs5mq89eka"
  to = azurerm_communication_service.res-1
}
