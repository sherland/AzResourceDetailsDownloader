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
  name       = "rg-ardl-76e93665472ab9d8"
  tags = {
    armType    = "Microsoft.Migrate/assessmentProjects"
    createdUtc = "2026-08-13T13:27:50.0240261Z"
    purpose    = "az-resource-details-downloader"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-76e93665472ab9d8"
  to = azurerm_resource_group.res-0
}
