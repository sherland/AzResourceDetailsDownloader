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
  name       = "rg-ardl-4ac8e1aaea384b1b"
  tags = {
    armType    = "Microsoft.App/jobs"
    createdUtc = "2026-08-16T14:33:19.1992948Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_container_app_job" "res-1" {
  container_app_environment_id = azurerm_container_app_environment.res-2.id
  location                     = "norwayeast"
  name                         = "cajouo-dwv4"
  replica_retry_limit          = 0
  replica_timeout_in_seconds   = 300
  resource_group_name          = azurerm_resource_group.res-0.name
  tags                         = {}
  workload_profile_name        = ""
  manual_trigger_config {
    parallelism              = 1
    replica_completion_count = 1
  }
  template {
    container {
      args    = []
      command = []
      cpu     = 0.5
      image   = "mcr.microsoft.com/azuredocs/aci-helloworld"
      memory  = "1Gi"
      name    = "main"
    }
  }
}
resource "azurerm_container_app_environment" "res-2" {
  dapr_application_insights_connection_string = "" # Masked sensitive attribute
  infrastructure_resource_group_name          = ""
  infrastructure_subnet_id                    = ""
  internal_load_balancer_enabled              = false
  location                                    = "norwayeast"
  log_analytics_workspace_id                  = ""
  logs_destination                            = ""
  mutual_tls_enabled                          = false
  name                                        = "caepmpb42xg"
  public_network_access                       = "Enabled"
  resource_group_name                         = azurerm_resource_group.res-0.name
  tags                                        = {}
  zone_redundancy_enabled                     = false
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-4ac8e1aaea384b1b"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-4ac8e1aaea384b1b/providers/Microsoft.App/jobs/cajouo-dwv4"
  to = azurerm_container_app_job.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-4ac8e1aaea384b1b/providers/Microsoft.App/managedEnvironments/caepmpb42xg"
  to = azurerm_container_app_environment.res-2
}
