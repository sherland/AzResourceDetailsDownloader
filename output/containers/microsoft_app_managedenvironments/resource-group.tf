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
  name       = "rg-ardl-4360456b29424ef8"
  tags = {
    armType    = "Microsoft.App/managedEnvironments"
    createdUtc = "2026-07-15T09:21:29.9324322Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_container_app_environment" "res-1" {
  dapr_application_insights_connection_string = "" # Masked sensitive attribute
  infrastructure_resource_group_name          = ""
  infrastructure_subnet_id                    = ""
  internal_load_balancer_enabled              = false
  location                                    = "westeurope"
  log_analytics_workspace_id                  = ""
  logs_destination                            = ""
  mutual_tls_enabled                          = false
  name                                        = "caef-y-ve5h"
  public_network_access                       = "Enabled"
  resource_group_name                         = azurerm_resource_group.res-0.name
  tags                                        = {}
  zone_redundancy_enabled                     = false
}
resource "azurerm_container_app_environment" "res-2" {
  dapr_application_insights_connection_string = "" # Masked sensitive attribute
  infrastructure_resource_group_name          = ""
  infrastructure_subnet_id                    = ""
  internal_load_balancer_enabled              = false
  location                                    = "francecentral"
  log_analytics_workspace_id                  = ""
  logs_destination                            = ""
  mutual_tls_enabled                          = false
  name                                        = "caez-5-26-t"
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
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-4360456b29424ef8/providers/Microsoft.App/managedEnvironments/caef-y-ve5h"
  to = azurerm_container_app_environment.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-4360456b29424ef8/providers/Microsoft.App/managedEnvironments/caez-5-26-t"
  to = azurerm_container_app_environment.res-2
}
