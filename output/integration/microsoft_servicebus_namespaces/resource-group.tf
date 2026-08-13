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
  name       = "rg-ardl-e325f80fb473f771"
  tags = {
    armType    = "Microsoft.ServiceBus/namespaces"
    createdUtc = "2026-08-14T06:58:40.9639473Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_servicebus_namespace" "res-1" {
  capacity                      = 0
  local_auth_enabled            = true
  location                      = "norwayeast"
  minimum_tls_version           = "1.2"
  name                          = "sb4hb2w-dr"
  premium_messaging_partitions  = 0
  public_network_access_enabled = true
  resource_group_name           = azurerm_resource_group.res-0.name
  sku                           = "Basic"
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


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-e325f80fb473f771"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-e325f80fb473f771/providers/Microsoft.ServiceBus/namespaces/sb4hb2w-dr"
  to = azurerm_servicebus_namespace.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-e325f80fb473f771/providers/Microsoft.ServiceBus/namespaces/sb4hb2w-dr/authorizationRules/RootManageSharedAccessKey"
  to = azurerm_servicebus_namespace_authorization_rule.res-2
}
