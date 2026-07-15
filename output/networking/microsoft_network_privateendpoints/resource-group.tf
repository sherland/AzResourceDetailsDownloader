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
  name       = "rg-ardl-3556a0936d77e0d2"
  tags = {
    armType    = "Microsoft.Network/privateEndpoints"
    createdUtc = "2026-07-15T18:33:24.1620822Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_private_endpoint" "res-1" {
  custom_network_interface_name = ""
  location                      = "westeurope"
  name                          = "penzc8co-v"
  resource_group_name           = azurerm_resource_group.res-0.name
  subnet_id                     = azurerm_subnet.res-3.id
  tags                          = {}
  private_service_connection {
    is_manual_connection              = false
    name                              = "peconn1"
    private_connection_resource_alias = ""
    private_connection_resource_id    = azurerm_storage_account.res-4.id
    request_message                   = ""
    subresource_names                 = ["blob"]
  }
}
resource "azurerm_virtual_network" "res-2" {
  address_space                  = ["10.42.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "westeurope"
  name                           = "vnet70-8j52w"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet = [{
    address_prefixes                              = ["10.42.0.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3556a0936d77e0d2/providers/Microsoft.Network/virtualNetworks/vnet70-8j52w/subnets/default"
    name                                          = "default"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }]
  tags = {}
}
resource "azurerm_subnet" "res-3" {
  address_prefixes                              = ["10.42.0.0/24"]
  default_outbound_access_enabled               = true
  name                                          = "default"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.res-0.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  sharing_scope                                 = ""
  virtual_network_name                          = "vnet70-8j52w"
  depends_on = [
    azurerm_virtual_network.res-2,
  ]
}
resource "azurerm_storage_account" "res-4" {
  access_tier                       = "Hot"
  account_kind                      = "StorageV2"
  account_replication_type          = "LRS"
  account_tier                      = "Standard"
  allow_nested_items_to_be_public   = false
  allowed_copy_scope                = ""
  cross_tenant_replication_enabled  = false
  default_to_oauth_authentication   = false
  dns_endpoint_type                 = "Standard"
  edge_zone                         = ""
  https_traffic_only_enabled        = true
  infrastructure_encryption_enabled = false
  is_hns_enabled                    = false
  large_file_share_enabled          = false
  local_user_enabled                = true
  location                          = "westeurope"
  min_tls_version                   = "TLS1_2"
  name                              = "st9crnw0b9"
  nfsv3_enabled                     = false
  primary_access_key                = "" # Masked sensitive attribute
  primary_blob_connection_string    = "" # Masked sensitive attribute
  primary_connection_string         = "" # Masked sensitive attribute
  provisioned_billing_model_version = ""
  public_network_access_enabled     = true
  queue_encryption_key_type         = "Service"
  resource_group_name               = azurerm_resource_group.res-0.name
  secondary_access_key              = "" # Masked sensitive attribute
  secondary_blob_connection_string  = "" # Masked sensitive attribute
  secondary_connection_string       = "" # Masked sensitive attribute
  sftp_enabled                      = false
  shared_access_key_enabled         = true
  table_encryption_key_type         = "Service"
  tags                              = {}
  blob_properties {
    change_feed_enabled           = false
    change_feed_retention_in_days = 0
    default_service_version       = ""
    last_access_time_enabled      = false
    versioning_enabled            = false
  }
  network_rules {
    bypass                     = ["None"]
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
  share_properties {
    retention_policy {
      days = 7
    }
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3556a0936d77e0d2"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3556a0936d77e0d2/providers/Microsoft.Network/privateEndpoints/penzc8co-v"
  to = azurerm_private_endpoint.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3556a0936d77e0d2/providers/Microsoft.Network/virtualNetworks/vnet70-8j52w"
  to = azurerm_virtual_network.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3556a0936d77e0d2/providers/Microsoft.Network/virtualNetworks/vnet70-8j52w/subnets/default"
  to = azurerm_subnet.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3556a0936d77e0d2/providers/Microsoft.Storage/storageAccounts/st9crnw0b9"
  to = azurerm_storage_account.res-4
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3556a0936d77e0d2/providers/Microsoft.Storage/storageAccounts/st9crnw0b9"
  to = azurerm_storage_account_queue_properties.res-8
}
