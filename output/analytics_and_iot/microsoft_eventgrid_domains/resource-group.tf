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
  name       = "rg-ardl-247f5bd34103ba1e"
  tags = {
    armType    = "Microsoft.EventGrid/domains"
    createdUtc = "2026-08-13T13:23:45.7385452Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_eventgrid_domain" "res-1" {
  auto_create_topic_with_first_subscription = true
  auto_delete_topic_with_last_subscription  = true
  inbound_ip_rule                           = []
  input_schema                              = "EventGridSchema"
  local_auth_enabled                        = true
  location                                  = "norwayeast"
  name                                      = "egduzo-u3om"
  public_network_access_enabled             = true
  resource_group_name                       = azurerm_resource_group.res-0.name
  tags                                      = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-247f5bd34103ba1e"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-247f5bd34103ba1e/providers/Microsoft.EventGrid/domains/egduzo-u3om"
  to = azurerm_eventgrid_domain.res-1
}
