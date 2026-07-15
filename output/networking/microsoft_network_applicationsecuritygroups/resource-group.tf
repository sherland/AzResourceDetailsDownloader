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
  name       = "rg-ardl-ba9eb33111484f38"
  tags = {
    armType    = "Microsoft.Network/applicationSecurityGroups"
    createdUtc = "2026-07-15T19:24:12.7275977Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_application_security_group" "res-1" {
  location            = "westeurope"
  name                = "asg02-5ciaw"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-ba9eb33111484f38"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-ba9eb33111484f38/providers/Microsoft.Network/applicationSecurityGroups/asg02-5ciaw"
  to = azurerm_application_security_group.res-1
}
