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
  name       = "rg-ardl-4360456b29424ef8"
  tags = {
    armType    = "Microsoft.App/managedEnvironments"
    createdUtc = "2026-08-13T14:35:11.0429965Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_container_app_environment" "res-1" {
  dapr_application_insights_connection_string = "" # Masked sensitive attribute
  infrastructure_resource_group_name          = ""
  infrastructure_subnet_id                    = ""
  internal_load_balancer_enabled              = false
  location                                    = "norwayeast"
  log_analytics_workspace_id                  = ""
  logs_destination                            = ""
  mutual_tls_enabled                          = false
  name                                        = "caeznfvtm-z"
  public_network_access                       = "Enabled"
  resource_group_name                         = azurerm_resource_group.res-0.name
  tags                                        = {}
  zone_redundancy_enabled                     = false
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-4360456b29424ef8"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-4360456b29424ef8/providers/Microsoft.App/managedEnvironments/caeznfvtm-z"
  to = azurerm_container_app_environment.res-1
}
