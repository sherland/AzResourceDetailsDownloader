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
  name       = "rg-ardl-86a49318bbcdb3bd"
  tags = {
    armType    = "Microsoft.ContainerRegistry/registries/webhooks"
    createdUtc = "2026-08-13T12:55:15.3290434Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_container_registry" "res-1" {
  admin_enabled                 = false
  anonymous_pull_enabled        = false
  data_endpoint_enabled         = false
  encryption                    = []
  export_policy_enabled         = true
  location                      = "norwayeast"
  name                          = "acrhuv0ipc0"
  network_rule_bypass_option    = "AzureServices"
  network_rule_set              = []
  public_network_access_enabled = true
  quarantine_policy_enabled     = false
  resource_group_name           = azurerm_resource_group.res-0.name
  retention_policy_in_days      = 0
  sku                           = "Standard"
  tags                          = {}
  trust_policy_enabled          = false
  zone_redundancy_enabled       = false
}
resource "azurerm_container_registry_scope_map" "res-2" {
  actions                 = ["repositories/*/metadata/read", "repositories/*/metadata/write", "repositories/*/content/read", "repositories/*/content/write", "repositories/*/content/delete"]
  container_registry_name = "acrhuv0ipc0"
  description             = "Can perform all read, write and delete operations on the registry"
  name                    = "_repositories_admin"
  resource_group_name     = azurerm_resource_group.res-0.name
  depends_on = [
    azurerm_container_registry.res-1,
  ]
}
resource "azurerm_container_registry_scope_map" "res-3" {
  actions                 = ["repositories/*/content/read"]
  container_registry_name = "acrhuv0ipc0"
  description             = "Can pull any repository of the registry"
  name                    = "_repositories_pull"
  resource_group_name     = azurerm_resource_group.res-0.name
  depends_on = [
    azurerm_container_registry.res-1,
  ]
}
resource "azurerm_container_registry_scope_map" "res-4" {
  actions                 = ["repositories/*/content/read", "repositories/*/metadata/read"]
  container_registry_name = "acrhuv0ipc0"
  description             = "Can perform all read operations on the registry"
  name                    = "_repositories_pull_metadata_read"
  resource_group_name     = azurerm_resource_group.res-0.name
  depends_on = [
    azurerm_container_registry.res-1,
  ]
}
resource "azurerm_container_registry_scope_map" "res-5" {
  actions                 = ["repositories/*/content/read", "repositories/*/content/write"]
  container_registry_name = "acrhuv0ipc0"
  description             = "Can push to any repository of the registry"
  name                    = "_repositories_push"
  resource_group_name     = azurerm_resource_group.res-0.name
  depends_on = [
    azurerm_container_registry.res-1,
  ]
}
resource "azurerm_container_registry_scope_map" "res-6" {
  actions                 = ["repositories/*/metadata/read", "repositories/*/metadata/write", "repositories/*/content/read", "repositories/*/content/write"]
  container_registry_name = "acrhuv0ipc0"
  description             = "Can perform all read and write operations on the registry"
  name                    = "_repositories_push_metadata_write"
  resource_group_name     = azurerm_resource_group.res-0.name
  depends_on = [
    azurerm_container_registry.res-1,
  ]
}
resource "azurerm_container_registry_webhook" "res-7" {
  actions             = ["push"]
  location            = "norwayeast"
  name                = "wh8jol6k"
  registry_name       = "acrhuv0ipc0"
  resource_group_name = azurerm_resource_group.res-0.name
  scope               = ""
  status              = "disabled"
  tags                = {}
  depends_on = [
    azurerm_container_registry.res-1,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-86a49318bbcdb3bd"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-86a49318bbcdb3bd/providers/Microsoft.ContainerRegistry/registries/acrhuv0ipc0"
  to = azurerm_container_registry.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-86a49318bbcdb3bd/providers/Microsoft.ContainerRegistry/registries/acrhuv0ipc0/scopeMaps/_repositories_admin"
  to = azurerm_container_registry_scope_map.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-86a49318bbcdb3bd/providers/Microsoft.ContainerRegistry/registries/acrhuv0ipc0/scopeMaps/_repositories_pull"
  to = azurerm_container_registry_scope_map.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-86a49318bbcdb3bd/providers/Microsoft.ContainerRegistry/registries/acrhuv0ipc0/scopeMaps/_repositories_pull_metadata_read"
  to = azurerm_container_registry_scope_map.res-4
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-86a49318bbcdb3bd/providers/Microsoft.ContainerRegistry/registries/acrhuv0ipc0/scopeMaps/_repositories_push"
  to = azurerm_container_registry_scope_map.res-5
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-86a49318bbcdb3bd/providers/Microsoft.ContainerRegistry/registries/acrhuv0ipc0/scopeMaps/_repositories_push_metadata_write"
  to = azurerm_container_registry_scope_map.res-6
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-86a49318bbcdb3bd/providers/Microsoft.ContainerRegistry/registries/acrhuv0ipc0/webHooks/wh8jol6k"
  to = azurerm_container_registry_webhook.res-7
}
