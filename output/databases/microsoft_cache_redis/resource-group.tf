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
  name       = "rg-ardl-e7dcd4c69ba978b0"
  tags = {
    armType    = "Microsoft.Cache/redis"
    createdUtc = "2026-07-15T18:23:03.9649979Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_redis_cache" "res-1" {
  access_keys_authentication_enabled = true
  capacity                           = 0
  family                             = "C"
  location                           = "westeurope"
  minimum_tls_version                = "1.2"
  name                               = "redisziu0dj94"
  non_ssl_port_enabled               = false
  primary_access_key                 = "" # Masked sensitive attribute
  primary_connection_string          = "" # Masked sensitive attribute
  private_static_ip_address          = ""
  public_network_access_enabled      = true
  redis_version                      = "6.0"
  replicas_per_master                = 0
  replicas_per_primary               = 0
  resource_group_name                = azurerm_resource_group.res-0.name
  secondary_access_key               = "" # Masked sensitive attribute
  secondary_connection_string        = "" # Masked sensitive attribute
  shard_count                        = 0
  sku_name                           = "Basic"
  subnet_id                          = ""
  tags                               = {}
  tenant_settings                    = {}
  zones                              = []
  redis_configuration {
    active_directory_authentication_enabled = false
    aof_backup_enabled                      = false
    aof_storage_connection_string_0         = "" # Masked sensitive attribute
    aof_storage_connection_string_1         = "" # Masked sensitive attribute
    authentication_enabled                  = true
    data_persistence_authentication_method  = ""
    maxfragmentationmemory_reserved         = 30
    maxmemory_delta                         = 30
    maxmemory_policy                        = ""
    maxmemory_reserved                      = 30
    notify_keyspace_events                  = ""
    rdb_backup_enabled                      = false
    rdb_backup_frequency                    = 0
    rdb_backup_max_snapshot_count           = 0
    rdb_storage_connection_string           = "" # Masked sensitive attribute
    storage_account_subscription_id         = ""
  }
}
resource "azurerm_redis_cache_access_policy" "res-2" {
  name           = "Data Contributor"
  permissions    = "+@all -@dangerous +cluster|info +cluster|nodes +cluster|slots allkeys"
  redis_cache_id = azurerm_redis_cache.res-1.id
}
resource "azurerm_redis_cache_access_policy" "res-3" {
  name           = "Data Owner"
  permissions    = "+@all allkeys"
  redis_cache_id = azurerm_redis_cache.res-1.id
}
resource "azurerm_redis_cache_access_policy" "res-4" {
  name           = "Data Reader"
  permissions    = "+@read +@connection +cluster|info +cluster|nodes +cluster|slots allkeys"
  redis_cache_id = azurerm_redis_cache.res-1.id
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-e7dcd4c69ba978b0"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-e7dcd4c69ba978b0/providers/Microsoft.Cache/redis/redisziu0dj94"
  to = azurerm_redis_cache.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-e7dcd4c69ba978b0/providers/Microsoft.Cache/redis/redisziu0dj94/accessPolicies/Data Contributor"
  to = azurerm_redis_cache_access_policy.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-e7dcd4c69ba978b0/providers/Microsoft.Cache/redis/redisziu0dj94/accessPolicies/Data Owner"
  to = azurerm_redis_cache_access_policy.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-e7dcd4c69ba978b0/providers/Microsoft.Cache/redis/redisziu0dj94/accessPolicies/Data Reader"
  to = azurerm_redis_cache_access_policy.res-4
}
