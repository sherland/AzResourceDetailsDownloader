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
  name       = "rg-ardl-8cbf4e82338a582d"
  tags = {
    armType    = "Microsoft.Databricks/accessConnectors"
    createdUtc = "2026-08-16T14:41:37.5616922Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_databricks_access_connector" "res-1" {
  location            = "norwayeast"
  name                = "dbacarwx6-ka"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-8cbf4e82338a582d"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-8cbf4e82338a582d/providers/Microsoft.Databricks/accessConnectors/dbacarwx6-ka"
  to = azurerm_databricks_access_connector.res-1
}
