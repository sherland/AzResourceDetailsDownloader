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
  name       = "rg-ardl-2356f0b7928705d0"
  tags = {
    armType    = "Microsoft.Compute/restorePointCollections"
    createdUtc = "2026-08-16T14:32:19.7623692Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_virtual_machine_restore_point_collection" "res-1" {
  location                  = "swedencentral"
  name                      = "rpc0q-1q-i1"
  resource_group_name       = azurerm_resource_group.res-0.name
  source_virtual_machine_id = azurerm_linux_virtual_machine.res-2.id
  tags                      = {}
}
resource "azurerm_linux_virtual_machine" "res-2" {
  admin_password                                         = "" # Masked sensitive attribute
  admin_username                                         = "azrddadmin"
  allow_extension_operations                             = true
  availability_set_id                                    = ""
  bypass_platform_safety_checks_on_user_schedule_enabled = false
  capacity_reservation_group_id                          = ""
  computer_name                                          = "ardlvm2"
  custom_data                                            = "" # Masked sensitive attribute
  dedicated_host_group_id                                = ""
  dedicated_host_id                                      = ""
  disable_password_authentication                        = false
  disk_controller_type                                   = ""
  edge_zone                                              = ""
  encryption_at_host_enabled                             = false
  eviction_policy                                        = ""
  extensions_time_budget                                 = "PT1H30M"
  license_type                                           = ""
  location                                               = "swedencentral"
  max_bid_price                                          = -1
  name                                                   = "swaz1fxf9i19802"
  network_interface_ids                                  = [azurerm_network_interface.res-3.id]
  os_managed_disk_id                                     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2356f0b7928705d0/providers/Microsoft.Compute/disks/swaz1fxf9i19802_OsDisk_1_f3d36c45e5de47f59a18720442ec198f"
  patch_assessment_mode                                  = "ImageDefault"
  patch_mode                                             = "ImageDefault"
  platform_fault_domain                                  = -1
  priority                                               = "Regular"
  provision_vm_agent                                     = true
  proximity_placement_group_id                           = ""
  reboot_setting                                         = ""
  resource_group_name                                    = azurerm_resource_group.res-0.name
  secure_boot_enabled                                    = false
  size                                                   = "Standard_D2s_v5"
  source_image_id                                        = ""
  tags                                                   = {}
  user_data                                              = ""
  virtual_machine_scale_set_id                           = ""
  vm_agent_platform_updates_enabled                      = true
  vtpm_enabled                                           = false
  zone                                                   = ""
  os_disk {
    caching                          = "ReadWrite"
    disk_encryption_set_id           = ""
    disk_size_gb                     = 30
    name                             = "swaz1fxf9i19802_OsDisk_1_f3d36c45e5de47f59a18720442ec198f"
    secure_vm_disk_encryption_set_id = ""
    security_encryption_type         = ""
    storage_account_type             = "StandardSSD_LRS"
    write_accelerator_enabled        = false
  }
  source_image_reference {
    offer     = "0001-com-ubuntu-server-jammy"
    publisher = "Canonical"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
resource "azurerm_network_interface" "res-3" {
  accelerated_networking_enabled = false
  auxiliary_mode                 = ""
  auxiliary_sku                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  internal_dns_name_label        = ""
  ip_forwarding_enabled          = false
  location                       = "swedencentral"
  name                           = "nic7a-5-uqh"
  resource_group_name            = azurerm_resource_group.res-0.name
  tags                           = {}
  ip_configuration {
    gateway_load_balancer_frontend_ip_configuration_id = ""
    name                                               = "ipconfig1"
    primary                                            = true
    private_ip_address                                 = "10.70.0.4"
    private_ip_address_allocation                      = "Dynamic"
    private_ip_address_version                         = "IPv4"
    public_ip_address_id                               = ""
    subnet_id                                          = azurerm_subnet.res-5.id
  }
}
resource "azurerm_virtual_network" "res-4" {
  address_space                  = ["10.70.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "swedencentral"
  name                           = "vnet4it9jcor"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet = [{
    address_prefixes                              = ["10.70.0.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2356f0b7928705d0/providers/Microsoft.Network/virtualNetworks/vnet4it9jcor/subnets/default"
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
resource "azurerm_subnet" "res-5" {
  address_prefixes                              = ["10.70.0.0/24"]
  default_outbound_access_enabled               = true
  name                                          = "default"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.res-0.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  sharing_scope                                 = ""
  virtual_network_name                          = "vnet4it9jcor"
  depends_on = [
    azurerm_virtual_network.res-4,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2356f0b7928705d0"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2356f0b7928705d0/providers/Microsoft.Compute/restorePointCollections/rpc0q-1q-i1"
  to = azurerm_virtual_machine_restore_point_collection.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2356f0b7928705d0/providers/Microsoft.Compute/virtualMachines/swaz1fxf9i19802"
  to = azurerm_linux_virtual_machine.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2356f0b7928705d0/providers/Microsoft.Network/networkInterfaces/nic7a-5-uqh"
  to = azurerm_network_interface.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2356f0b7928705d0/providers/Microsoft.Network/virtualNetworks/vnet4it9jcor"
  to = azurerm_virtual_network.res-4
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2356f0b7928705d0/providers/Microsoft.Network/virtualNetworks/vnet4it9jcor/subnets/default"
  to = azurerm_subnet.res-5
}
