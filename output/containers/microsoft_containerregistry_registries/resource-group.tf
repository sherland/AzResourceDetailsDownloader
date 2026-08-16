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
  name       = "rg-ardl-1bbbd6c0728e9e29"
  tags = {
    armType    = "Microsoft.ContainerRegistry/registries"
    createdUtc = "2026-08-16T13:24:49.8129287Z"
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
  name                          = "acrp0etmvv1"
  network_rule_bypass_option    = "AzureServices"
  network_rule_set              = []
  public_network_access_enabled = true
  quarantine_policy_enabled     = false
  resource_group_name           = azurerm_resource_group.res-0.name
  retention_policy_in_days      = 0
  sku                           = "Basic"
  tags                          = {}
  trust_policy_enabled          = false
  zone_redundancy_enabled       = false
}
resource "azurerm_container_registry_scope_map" "res-2" {
  actions                 = ["repositories/*/metadata/read", "repositories/*/metadata/write", "repositories/*/content/read", "repositories/*/content/write", "repositories/*/content/delete"]
  container_registry_name = "acrp0etmvv1"
  description             = "Can perform all read, write and delete operations on the registry"
  name                    = "_repositories_admin"
  resource_group_name     = azurerm_resource_group.res-0.name
  depends_on = [
    azurerm_container_registry.res-1,
  ]
}
resource "azurerm_container_registry_scope_map" "res-3" {
  actions                 = ["repositories/*/content/read"]
  container_registry_name = "acrp0etmvv1"
  description             = "Can pull any repository of the registry"
  name                    = "_repositories_pull"
  resource_group_name     = azurerm_resource_group.res-0.name
  depends_on = [
    azurerm_container_registry.res-1,
  ]
}
resource "azurerm_container_registry_scope_map" "res-4" {
  actions                 = ["repositories/*/content/read", "repositories/*/metadata/read"]
  container_registry_name = "acrp0etmvv1"
  description             = "Can perform all read operations on the registry"
  name                    = "_repositories_pull_metadata_read"
  resource_group_name     = azurerm_resource_group.res-0.name
  depends_on = [
    azurerm_container_registry.res-1,
  ]
}
resource "azurerm_container_registry_scope_map" "res-5" {
  actions                 = ["repositories/*/content/read", "repositories/*/content/write"]
  container_registry_name = "acrp0etmvv1"
  description             = "Can push to any repository of the registry"
  name                    = "_repositories_push"
  resource_group_name     = azurerm_resource_group.res-0.name
  depends_on = [
    azurerm_container_registry.res-1,
  ]
}
resource "azurerm_container_registry_scope_map" "res-6" {
  actions                 = ["repositories/*/metadata/read", "repositories/*/metadata/write", "repositories/*/content/read", "repositories/*/content/write"]
  container_registry_name = "acrp0etmvv1"
  description             = "Can perform all read and write operations on the registry"
  name                    = "_repositories_push_metadata_write"
  resource_group_name     = azurerm_resource_group.res-0.name
  depends_on = [
    azurerm_container_registry.res-1,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1bbbd6c0728e9e29"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1bbbd6c0728e9e29/providers/Microsoft.ContainerRegistry/registries/acrp0etmvv1"
  to = azurerm_container_registry.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1bbbd6c0728e9e29/providers/Microsoft.ContainerRegistry/registries/acrp0etmvv1/scopeMaps/_repositories_admin"
  to = azurerm_container_registry_scope_map.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1bbbd6c0728e9e29/providers/Microsoft.ContainerRegistry/registries/acrp0etmvv1/scopeMaps/_repositories_pull"
  to = azurerm_container_registry_scope_map.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1bbbd6c0728e9e29/providers/Microsoft.ContainerRegistry/registries/acrp0etmvv1/scopeMaps/_repositories_pull_metadata_read"
  to = azurerm_container_registry_scope_map.res-4
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1bbbd6c0728e9e29/providers/Microsoft.ContainerRegistry/registries/acrp0etmvv1/scopeMaps/_repositories_push"
  to = azurerm_container_registry_scope_map.res-5
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1bbbd6c0728e9e29/providers/Microsoft.ContainerRegistry/registries/acrp0etmvv1/scopeMaps/_repositories_push_metadata_write"
  to = azurerm_container_registry_scope_map.res-6
}
