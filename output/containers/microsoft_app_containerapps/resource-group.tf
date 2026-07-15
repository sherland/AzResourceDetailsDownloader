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
  name       = "rg-ardl-83e0b3aed1165e3b"
  tags = {
    armType    = "Microsoft.App/containerApps"
    createdUtc = "2026-07-15T09:21:47.2230862Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_container_app" "res-1" {
  container_app_environment_id  = azurerm_container_app_environment.res-3.id
  custom_domain_verification_id = "" # Masked sensitive attribute
  max_inactive_revisions        = 100
  name                          = "ca453klp91"
  resource_group_name           = azurerm_resource_group.res-0.name
  revision_mode                 = "Single"
  tags                          = {}
  workload_profile_name         = ""
  ingress {
    allow_insecure_connections = false
    client_certificate_mode    = ""
    exposed_port               = 0
    external_enabled           = true
    target_port                = 80
    transport                  = "auto"
    traffic_weight {
      label           = ""
      latest_revision = true
      percentage      = 100
      revision_suffix = ""
    }
  }
  template {
    cooldown_period_in_seconds       = 300
    max_replicas                     = 10
    min_replicas                     = 0
    polling_interval_in_seconds      = 30
    revision_suffix                  = ""
    termination_grace_period_seconds = 0
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
  location                                    = "westeurope"
  log_analytics_workspace_id                  = ""
  logs_destination                            = ""
  mutual_tls_enabled                          = false
  name                                        = "caedj4q0www"
  public_network_access                       = "Enabled"
  resource_group_name                         = azurerm_resource_group.res-0.name
  tags                                        = {}
  zone_redundancy_enabled                     = false
}
resource "azurerm_container_app_environment" "res-3" {
  dapr_application_insights_connection_string = "" # Masked sensitive attribute
  infrastructure_resource_group_name          = ""
  infrastructure_subnet_id                    = ""
  internal_load_balancer_enabled              = false
  location                                    = "francecentral"
  log_analytics_workspace_id                  = ""
  logs_destination                            = ""
  mutual_tls_enabled                          = false
  name                                        = "caesiujm-j3"
  public_network_access                       = "Enabled"
  resource_group_name                         = azurerm_resource_group.res-0.name
  tags                                        = {}
  zone_redundancy_enabled                     = false
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-83e0b3aed1165e3b"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-83e0b3aed1165e3b/providers/Microsoft.App/containerApps/ca453klp91"
  to = azurerm_container_app.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-83e0b3aed1165e3b/providers/Microsoft.App/managedEnvironments/caedj4q0www"
  to = azurerm_container_app_environment.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-83e0b3aed1165e3b/providers/Microsoft.App/managedEnvironments/caesiujm-j3"
  to = azurerm_container_app_environment.res-3
}
