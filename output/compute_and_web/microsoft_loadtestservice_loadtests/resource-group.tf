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
  name       = "rg-ardl-6ac66ccaa8351863"
  tags = {
    armType    = "Microsoft.LoadTestService/loadTests"
    createdUtc = "2026-08-16T14:34:18.8675457Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_load_test" "res-1" {
  description         = "ARDL load test resource"
  location            = "swedencentral"
  name                = "ltft68qr-q"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-6ac66ccaa8351863"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-6ac66ccaa8351863/providers/Microsoft.LoadTestService/loadTests/ltft68qr-q"
  to = azurerm_load_test.res-1
}
