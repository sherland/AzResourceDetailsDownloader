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
  name       = "rg-ardl-4bfc2889e6ff55e5"
  tags = {
    armType    = "Microsoft.EventGrid/domains/topics"
    createdUtc = "2026-07-15T19:15:33.7317111Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_eventgrid_domain" "res-1" {
  auto_create_topic_with_first_subscription = true
  auto_delete_topic_with_last_subscription  = true
  inbound_ip_rule                           = []
  input_schema                              = "EventGridSchema"
  local_auth_enabled                        = true
  location                                  = "westeurope"
  name                                      = "egdy-n1aqei"
  primary_access_key                        = "" # Masked sensitive attribute
  public_network_access_enabled             = true
  resource_group_name                       = azurerm_resource_group.res-0.name
  secondary_access_key                      = "" # Masked sensitive attribute
  tags                                      = {}
}
resource "azurerm_eventgrid_domain_topic" "res-2" {
  domain_name         = "egdy-n1aqei"
  name                = "topicc-yh-q"
  resource_group_name = azurerm_resource_group.res-0.name
  depends_on = [
    azurerm_eventgrid_domain.res-1,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-4bfc2889e6ff55e5"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-4bfc2889e6ff55e5/providers/Microsoft.EventGrid/domains/egdy-n1aqei"
  to = azurerm_eventgrid_domain.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-4bfc2889e6ff55e5/providers/Microsoft.EventGrid/domains/egdy-n1aqei/topics/topicc-yh-q"
  to = azurerm_eventgrid_domain_topic.res-2
}
