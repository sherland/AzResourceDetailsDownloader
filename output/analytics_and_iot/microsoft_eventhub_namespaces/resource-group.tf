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
  name       = "rg-ardl-dced82a8791f5059"
  tags = {
    armType    = "Microsoft.EventHub/namespaces"
    createdUtc = "2026-08-16T13:33:25.6011584Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_eventhub_namespace" "res-1" {
  auto_inflate_enabled         = false
  capacity                     = 1
  dedicated_cluster_id         = ""
  local_authentication_enabled = true
  location                     = "norwayeast"
  maximum_throughput_units     = 0
  minimum_tls_version          = "1.2"
  name                         = "ehnsw2y13x4d"
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
  listen              = true
  manage              = true
  name                = "RootManageSharedAccessKey"
  namespace_name      = "ehnsw2y13x4d"
  resource_group_name = azurerm_resource_group.res-0.name
  send                = true
  depends_on = [
    azurerm_eventhub_namespace.res-1,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-dced82a8791f5059"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-dced82a8791f5059/providers/Microsoft.EventHub/namespaces/ehnsw2y13x4d"
  to = azurerm_eventhub_namespace.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-dced82a8791f5059/providers/Microsoft.EventHub/namespaces/ehnsw2y13x4d/authorizationRules/RootManageSharedAccessKey"
  to = azurerm_eventhub_namespace_authorization_rule.res-2
}
