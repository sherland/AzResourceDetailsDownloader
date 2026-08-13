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
  name       = "rg-ardl-c8862d85f1cc8103"
  tags = {
    armType    = "Microsoft.DigitalTwins/digitalTwinsInstances"
    createdUtc = "2026-08-13T14:15:00.2077445Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_digital_twins_instance" "res-1" {
  location            = "northeurope"
  name                = "dt4wdx8el0"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c8862d85f1cc8103"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c8862d85f1cc8103/providers/Microsoft.DigitalTwins/digitalTwinsInstances/dt4wdx8el0"
  to = azurerm_digital_twins_instance.res-1
}
