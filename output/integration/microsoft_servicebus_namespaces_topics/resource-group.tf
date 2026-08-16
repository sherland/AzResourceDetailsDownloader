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
  name       = "rg-ardl-7213c5cee239bcf7"
  tags = {
    armType    = "Microsoft.ServiceBus/namespaces/topics"
    createdUtc = "2026-08-16T14:12:09.6393848Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_servicebus_namespace" "res-1" {
  capacity                      = 0
  local_auth_enabled            = true
  location                      = "norwayeast"
  minimum_tls_version           = "1.2"
  name                          = "sbalnbuxtr"
  premium_messaging_partitions  = 0
  public_network_access_enabled = true
  resource_group_name           = azurerm_resource_group.res-0.name
  sku                           = "Standard"
  tags                          = {}
  network_rule_set {
    default_action                = "Allow"
    ip_rules                      = []
    public_network_access_enabled = true
    trusted_services_allowed      = false
  }
}
resource "azurerm_servicebus_namespace_authorization_rule" "res-2" {
  listen       = true
  manage       = true
  name         = "RootManageSharedAccessKey"
  namespace_id = azurerm_servicebus_namespace.res-1.id
  send         = true
}
resource "azurerm_servicebus_topic" "res-4" {
  auto_delete_on_idle                     = "P10675199DT2H48M5.4775807S"
  batched_operations_enabled              = true
  default_message_ttl                     = "P10675199DT2H48M5.4775807S"
  duplicate_detection_history_time_window = "PT10M"
  express_enabled                         = false
  max_message_size_in_kilobytes           = 256
  max_size_in_megabytes                   = 1024
  name                                    = "topicv0fcfy"
  namespace_id                            = azurerm_servicebus_namespace.res-1.id
  partitioning_enabled                    = false
  requires_duplicate_detection            = false
  status                                  = "Active"
  support_ordering                        = true
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7213c5cee239bcf7"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7213c5cee239bcf7/providers/Microsoft.ServiceBus/namespaces/sbalnbuxtr"
  to = azurerm_servicebus_namespace.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7213c5cee239bcf7/providers/Microsoft.ServiceBus/namespaces/sbalnbuxtr/authorizationRules/RootManageSharedAccessKey"
  to = azurerm_servicebus_namespace_authorization_rule.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7213c5cee239bcf7/providers/Microsoft.ServiceBus/namespaces/sbalnbuxtr/topics/topicv0fcfy"
  to = azurerm_servicebus_topic.res-4
}
