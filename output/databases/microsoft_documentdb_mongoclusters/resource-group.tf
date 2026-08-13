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
  name       = "rg-ardl-74a9554cec74d742"
  tags = {
    armType    = "Microsoft.DocumentDB/mongoClusters"
    createdUtc = "2026-08-14T10:41:24.4508210Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_mongo_cluster" "res-1" {
  administrator_password = "" # Masked sensitive attribute
  administrator_username = "azrddadmin"
  authentication_methods = ["NativeAuth"]
  compute_tier           = "M10"
  create_mode            = ""
  data_api_mode_enabled  = false
  high_availability_mode = "Disabled"
  location               = "norwayeast"
  name                   = "mcmfaoowj5"
  preview_features       = []
  public_network_access  = "Enabled"
  resource_group_name    = azurerm_resource_group.res-0.name
  shard_count            = 1
  source_location        = ""
  source_server_id       = ""
  storage_size_in_gb     = 32
  storage_type           = "PremiumSSD"
  tags                   = {}
  version                = "7.0"
}
resource "azurerm_mongo_cluster_user" "res-2" {
  identity_provider_type = ""
  mongo_cluster_id       = azurerm_mongo_cluster.res-1.id
  object_id              = "azrddadmin"
  principal_type         = ""
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-74a9554cec74d742"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-74a9554cec74d742/providers/Microsoft.DocumentDB/mongoClusters/mcmfaoowj5"
  to = azurerm_mongo_cluster.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-74a9554cec74d742/providers/Microsoft.DocumentDB/mongoClusters/mcmfaoowj5/users/azrddadmin"
  to = azurerm_mongo_cluster_user.res-2
}
