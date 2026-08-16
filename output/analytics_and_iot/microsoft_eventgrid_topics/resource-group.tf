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
  name       = "rg-ardl-2eaf0495e72b2415"
  tags = {
    armType    = "Microsoft.EventGrid/topics"
    createdUtc = "2026-08-16T13:27:16.7227687Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_eventgrid_topic" "res-1" {
  inbound_ip_rule               = []
  input_schema                  = "EventGridSchema"
  local_auth_enabled            = true
  location                      = "norwayeast"
  name                          = "egt1y0so60i"
  public_network_access_enabled = true
  resource_group_name           = azurerm_resource_group.res-0.name
  tags                          = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2eaf0495e72b2415"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2eaf0495e72b2415/providers/Microsoft.EventGrid/topics/egt1y0so60i"
  to = azurerm_eventgrid_topic.res-1
}
