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
  name       = "rg-ardl-d94a1e445813b7b4"
  tags = {
    armType    = "Microsoft.Network/serviceEndPointPolicies"
    createdUtc = "2026-08-13T13:34:04.9093125Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_subnet_service_endpoint_storage_policy" "res-1" {
  location            = "norwayeast"
  name                = "sepaibfiwep"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d94a1e445813b7b4"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d94a1e445813b7b4/providers/Microsoft.Network/serviceEndpointPolicies/sepaibfiwep"
  to = azurerm_subnet_service_endpoint_storage_policy.res-1
}
