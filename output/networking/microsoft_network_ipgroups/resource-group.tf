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
  name       = "rg-ardl-a6f2232c1cae065f"
  tags = {
    armType    = "Microsoft.Network/ipGroups"
    createdUtc = "2026-08-14T10:50:54.1488128Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_ip_group" "res-1" {
  cidrs               = ["10.50.0.0/24"]
  location            = "norwayeast"
  name                = "ipg3612-y64"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a6f2232c1cae065f"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a6f2232c1cae065f/providers/Microsoft.Network/ipGroups/ipg3612-y64"
  to = azurerm_ip_group.res-1
}
