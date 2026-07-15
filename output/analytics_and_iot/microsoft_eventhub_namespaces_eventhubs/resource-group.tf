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
  name       = "rg-ardl-39c48c262400e678"
  tags = {
    armType    = "Microsoft.EventHub/namespaces/eventHubs"
    createdUtc = "2026-07-15T19:10:27.9427578Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_eventhub_namespace" "res-1" {
  auto_inflate_enabled                      = false
  capacity                                  = 1
  dedicated_cluster_id                      = ""
  default_primary_connection_string         = "" # Masked sensitive attribute
  default_primary_connection_string_alias   = "" # Masked sensitive attribute
  default_primary_key                       = "" # Masked sensitive attribute
  default_secondary_connection_string       = "" # Masked sensitive attribute
  default_secondary_connection_string_alias = "" # Masked sensitive attribute
  default_secondary_key                     = "" # Masked sensitive attribute
  local_authentication_enabled              = true
  location                                  = "westeurope"
  maximum_throughput_units                  = 0
  minimum_tls_version                       = "1.2"
  name                                      = "ehns2z7d7gyo"
  network_rulesets = [{
    default_action                 = "Allow"
    ip_rule                        = []
    public_network_access_enabled  = true
    trusted_service_access_enabled = false
    virtual_network_rule           = []
  }]
  public_network_access_enabled = true
  resource_group_name           = azurerm_resource_group.res-0.name
  sku                           = "Basic"
  tags                          = {}
}
resource "azurerm_eventhub_namespace_authorization_rule" "res-2" {
  listen                            = true
  manage                            = true
  name                              = "RootManageSharedAccessKey"
  namespace_name                    = "ehns2z7d7gyo"
  primary_connection_string         = "" # Masked sensitive attribute
  primary_connection_string_alias   = "" # Masked sensitive attribute
  primary_key                       = "" # Masked sensitive attribute
  resource_group_name               = azurerm_resource_group.res-0.name
  secondary_connection_string       = "" # Masked sensitive attribute
  secondary_connection_string_alias = "" # Masked sensitive attribute
  secondary_key                     = "" # Masked sensitive attribute
  send                              = true
  depends_on = [
    azurerm_eventhub_namespace.res-1,
  ]
}
resource "azurerm_eventhub" "res-3" {
  message_retention   = 1
  name                = "ehu6z-fa"
  namespace_id        = azurerm_eventhub_namespace.res-1.id
  namespace_name      = "ehns2z7d7gyo"
  partition_count     = 1
  resource_group_name = azurerm_resource_group.res-0.name
  status              = "Active"
  retention_description {
    cleanup_policy                    = "Delete"
    retention_time_in_hours           = 24
    tombstone_retention_time_in_hours = 0
  }
}
resource "azurerm_eventhub_consumer_group" "res-4" {
  eventhub_name       = "ehu6z-fa"
  name                = "$Default"
  namespace_name      = "ehns2z7d7gyo"
  resource_group_name = azurerm_resource_group.res-0.name
  user_metadata       = ""
  depends_on = [
    azurerm_eventhub.res-3,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-39c48c262400e678"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-39c48c262400e678/providers/Microsoft.EventHub/namespaces/ehns2z7d7gyo"
  to = azurerm_eventhub_namespace.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-39c48c262400e678/providers/Microsoft.EventHub/namespaces/ehns2z7d7gyo/authorizationRules/RootManageSharedAccessKey"
  to = azurerm_eventhub_namespace_authorization_rule.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-39c48c262400e678/providers/Microsoft.EventHub/namespaces/ehns2z7d7gyo/eventhubs/ehu6z-fa"
  to = azurerm_eventhub.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-39c48c262400e678/providers/Microsoft.EventHub/namespaces/ehns2z7d7gyo/eventhubs/ehu6z-fa/consumerGroups/$Default"
  to = azurerm_eventhub_consumer_group.res-4
}
