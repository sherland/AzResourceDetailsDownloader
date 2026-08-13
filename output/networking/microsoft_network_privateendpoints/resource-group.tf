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
  name       = "rg-ardl-3556a0936d77e0d2"
  tags = {
    armType    = "Microsoft.Network/privateEndpoints"
    createdUtc = "2026-08-13T14:02:24.1949292Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_private_endpoint" "res-1" {
  custom_network_interface_name = ""
  location                      = "norwayeast"
  name                          = "peavc8p-9p"
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
  location                       = "norwayeast"
  name                           = "vnetari4-k-l"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet = [{
    address_prefixes                              = ["10.42.0.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3556a0936d77e0d2/providers/Microsoft.Network/virtualNetworks/vnetari4-k-l/subnets/default"
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
  virtual_network_name                          = "vnetari4-k-l"
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
  location                          = "norwayeast"
  min_tls_version                   = "TLS1_2"
  name                              = "stzbwkrmnn"
  nfsv3_enabled                     = false
  provisioned_billing_model_version = ""
  public_network_access_enabled     = true
  queue_encryption_key_type         = "Service"
  resource_group_name               = azurerm_resource_group.res-0.name
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
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3556a0936d77e0d2/providers/Microsoft.Network/privateEndpoints/peavc8p-9p"
  to = azurerm_private_endpoint.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3556a0936d77e0d2/providers/Microsoft.Network/virtualNetworks/vnetari4-k-l"
  to = azurerm_virtual_network.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3556a0936d77e0d2/providers/Microsoft.Network/virtualNetworks/vnetari4-k-l/subnets/default"
  to = azurerm_subnet.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3556a0936d77e0d2/providers/Microsoft.Storage/storageAccounts/stzbwkrmnn"
  to = azurerm_storage_account.res-4
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3556a0936d77e0d2/providers/Microsoft.Storage/storageAccounts/stzbwkrmnn"
  to = azurerm_storage_account_queue_properties.res-8
}
