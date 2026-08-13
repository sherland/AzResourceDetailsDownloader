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
  name       = "rg-ardl-ba9eb33111484f38"
  tags = {
    armType    = "Microsoft.Network/applicationSecurityGroups"
    createdUtc = "2026-08-14T10:50:42.1430130Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_application_security_group" "res-1" {
  location            = "norwayeast"
  name                = "asgd0cn8mn8"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-ba9eb33111484f38"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-ba9eb33111484f38/providers/Microsoft.Network/applicationSecurityGroups/asgd0cn8mn8"
  to = azurerm_application_security_group.res-1
}
