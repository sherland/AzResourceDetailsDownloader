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
  name       = "rg-ardl-76e93665472ab9d8"
  tags = {
    armType    = "Microsoft.Migrate/assessmentProjects"
    createdUtc = "2026-07-15T19:23:10.7021656Z"
    purpose    = "az-resource-details-downloader"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-76e93665472ab9d8"
  to = azurerm_resource_group.res-0
}
