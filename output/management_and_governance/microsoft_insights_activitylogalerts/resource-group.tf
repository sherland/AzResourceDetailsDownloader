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
  name       = "rg-ardl-0b366a4f497d75e9"
  tags = {
    armType    = "Microsoft.Insights/activityLogAlerts"
    createdUtc = "2026-08-13T13:05:31.6441314Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_monitor_activity_log_alert" "res-1" {
  description         = ""
  enabled             = true
  location            = "global"
  name                = "ala5t-j-5-o"
  resource_group_name = azurerm_resource_group.res-0.name
  scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
  tags                = {}
  criteria {
    caller                  = ""
    category                = "ServiceHealth"
    level                   = ""
    levels                  = []
    operation_name          = ""
    recommendation_category = ""
    recommendation_impact   = ""
    recommendation_type     = ""
    resource_group          = ""
    resource_groups         = []
    resource_id             = ""
    resource_ids            = []
    resource_provider       = ""
    resource_providers      = []
    resource_type           = ""
    resource_types          = []
    status                  = ""
    statuses                = []
    sub_status              = ""
    sub_statuses            = []
    service_health {
    }
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-0b366a4f497d75e9"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-0b366a4f497d75e9/providers/Microsoft.Insights/activityLogAlerts/ala5t-j-5-o"
  to = azurerm_monitor_activity_log_alert.res-1
}
