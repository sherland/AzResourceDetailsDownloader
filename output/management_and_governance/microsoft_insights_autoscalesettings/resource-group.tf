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
  name       = "rg-ardl-cc2b66fdbbabfb9f"
  tags = {
    armType    = "Microsoft.Insights/autoscalesettings"
    createdUtc = "2026-08-13T14:53:21.1286318Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_monitor_autoscale_setting" "res-1" {
  enabled             = true
  location            = "swedencentral"
  name                = "asp-mww-u3"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
  target_resource_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-cc2b66fdbbabfb9f/providers/Microsoft.Web/serverfarms/planxsbsuyv2"
  profile {
    name = "default"
    capacity {
      default = 1
      maximum = 1
      minimum = 1
    }
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-cc2b66fdbbabfb9f"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-cc2b66fdbbabfb9f/providers/Microsoft.Insights/autoScaleSettings/asp-mww-u3"
  to = azurerm_monitor_autoscale_setting.res-1
}
