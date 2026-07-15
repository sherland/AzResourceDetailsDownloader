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
  name       = "rg-ardl-a482ee03d0d47514"
  tags = {
    armType    = "Microsoft.Compute/virtualMachineScaleSets"
    createdUtc = "2026-07-15T19:04:56.2458069Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_linux_virtual_machine_scale_set" "res-1" {
  admin_password                                    = "" # Masked sensitive attribute
  admin_username                                    = "azrddadmin"
  capacity_reservation_group_id                     = ""
  computer_name_prefix                              = "ardlvmss"
  custom_data                                       = "" # Masked sensitive attribute
  disable_password_authentication                   = false
  do_not_run_extensions_on_overprovisioned_machines = false
  edge_zone                                         = ""
  encryption_at_host_enabled                        = false
  eviction_policy                                   = ""
  extension_operations_enabled                      = true
  extensions_time_budget                            = "PT1H30M"
  health_probe_id                                   = ""
  instances                                         = 1
  location                                          = "westeurope"
  max_bid_price                                     = -1
  name                                              = "vmsswdgknl"
  overprovision                                     = true
  platform_fault_domain_count                       = 5
  priority                                          = "Regular"
  provision_vm_agent                                = true
  proximity_placement_group_id                      = ""
  resilient_vm_creation_enabled                     = false
  resilient_vm_deletion_enabled                     = false
  resource_group_name                               = azurerm_resource_group.res-0.name
  secure_boot_enabled                               = false
  single_placement_group                            = true
  sku                                               = "Standard_D2s_v5"
  source_image_id                                   = ""
  tags                                              = {}
  upgrade_mode                                      = "Manual"
  user_data                                         = ""
  vtpm_enabled                                      = false
  zone_balance                                      = false
  zones                                             = []
  network_interface {
    auxiliary_mode                = ""
    auxiliary_sku                 = ""
    dns_servers                   = []
    enable_accelerated_networking = false
    enable_ip_forwarding          = false
    name                          = "nicconfig1"
    network_security_group_id     = ""
    primary                       = true
    ip_configuration {
      application_gateway_backend_address_pool_ids = []
      application_security_group_ids               = []
      load_balancer_backend_address_pool_ids       = []
      load_balancer_inbound_nat_rules_ids          = []
      name                                         = "ipconfig1"
      primary                                      = false
      subnet_id                                    = azurerm_subnet.res-4.id
      version                                      = "IPv4"
    }
  }
  os_disk {
    caching                          = "None"
    disk_encryption_set_id           = ""
    disk_size_gb                     = 30
    secure_vm_disk_encryption_set_id = ""
    security_encryption_type         = ""
    storage_account_type             = "Premium_LRS"
    write_accelerator_enabled        = false
  }
  source_image_reference {
    offer     = "0001-com-ubuntu-server-jammy"
    publisher = "Canonical"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
resource "azurerm_virtual_network" "res-3" {
  address_space                  = ["10.46.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "westeurope"
  name                           = "vnetd7-ts-wt"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet = [{
    address_prefixes                              = ["10.46.0.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a482ee03d0d47514/providers/Microsoft.Network/virtualNetworks/vnetd7-ts-wt/subnets/default"
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
resource "azurerm_subnet" "res-4" {
  address_prefixes                              = ["10.46.0.0/24"]
  default_outbound_access_enabled               = true
  name                                          = "default"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.res-0.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  sharing_scope                                 = ""
  virtual_network_name                          = "vnetd7-ts-wt"
  depends_on = [
    azurerm_virtual_network.res-3,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a482ee03d0d47514"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a482ee03d0d47514/providers/Microsoft.Compute/virtualMachineScaleSets/vmsswdgknl"
  to = azurerm_linux_virtual_machine_scale_set.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a482ee03d0d47514/providers/Microsoft.Network/virtualNetworks/vnetd7-ts-wt"
  to = azurerm_virtual_network.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a482ee03d0d47514/providers/Microsoft.Network/virtualNetworks/vnetd7-ts-wt/subnets/default"
  to = azurerm_subnet.res-4
}
