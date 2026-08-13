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
  name       = "rg-ardl-9453358d1e4e04fe"
  tags = {
    armType    = "Microsoft.Devices/IotHubs"
    createdUtc = "2026-08-13T13:16:23.6399777Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_iothub" "res-1" {
  endpoint                     = []
  enrichment                   = []
  event_hub_partition_count    = 2
  event_hub_retention_in_days  = 1
  local_authentication_enabled = true
  location                     = "norwayeast"
  min_tls_version              = "1.2"
  name                         = "iot19ncaw4p"
  resource_group_name          = azurerm_resource_group.res-0.name
  route                        = []
  tags                         = {}
  cloud_to_device {
    default_ttl        = "PT1H"
    max_delivery_count = 10
    feedback {
      lock_duration      = "PT1M"
      max_delivery_count = 10
      time_to_live       = "PT1H"
    }
  }
  fallback_route {
    condition      = "true"
    enabled        = true
    endpoint_names = ["events"]
    source         = "DeviceMessages"
  }
  file_upload {
    authentication_type = "keyBased"
    connection_string   = "" # Masked sensitive attribute
    container_name      = ""
    default_ttl         = "PT1H"
    identity_id         = ""
    lock_duration       = "PT1M"
    max_delivery_count  = 10
    notifications       = false
    sas_ttl             = "PT1H"
  }
  sku {
    capacity = 1
    name     = "F1"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9453358d1e4e04fe"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9453358d1e4e04fe/providers/Microsoft.Devices/iotHubs/iot19ncaw4p"
  to = azurerm_iothub.res-1
}
