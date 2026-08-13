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
  name       = "rg-ardl-a24d83ecaa8ef94f"
  tags = {
    armType    = "Microsoft.AlertsManagement/actionRules"
    createdUtc = "2026-08-13T13:28:03.1733865Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_monitor_alert_processing_rule_suppression" "res-1" {
  description         = ""
  enabled             = true
  name                = "apryflw03-r"
  resource_group_name = azurerm_resource_group.res-0.name
  scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a24d83ecaa8ef94f"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a24d83ecaa8ef94f/providers/Microsoft.AlertsManagement/actionRules/apryflw03-r"
  to = azurerm_monitor_alert_processing_rule_suppression.res-1
}
