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
  name       = "rg-ardl-7c2bfad159d510c2"
  tags = {
    armType    = "Microsoft.ContainerService/managedClusters"
    createdUtc = "2026-08-14T10:41:53.7911420Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_kubernetes_cluster" "res-1" {
  ai_toolchain_operator_enabled       = false
  automatic_upgrade_channel           = ""
  cost_analysis_enabled               = false
  custom_ca_trust_certificates_base64 = []
  disk_encryption_set_id              = ""
  dns_prefix                          = "ardlaksdr835j"
  dns_prefix_private_cluster          = ""
  edge_zone                           = ""
  kubernetes_version                  = "1.35"
  local_account_disabled              = false
  location                            = "swedencentral"
  name                                = "aksb4ef4-7r"
  node_os_upgrade_channel             = "NodeImage"
  node_resource_group                 = "MC_rg-ardl-7c2bfad159d510c2_aksb4ef4-7r_swedencentral"
  oidc_issuer_enabled                 = true
  private_cluster_enabled             = false
  private_cluster_public_fqdn_enabled = false
  private_dns_zone_id                 = ""
  resource_group_name                 = azurerm_resource_group.res-0.name
  role_based_access_control_enabled   = true
  run_command_enabled                 = true
  sku_tier                            = "Free"
  support_plan                        = "KubernetesOfficial"
  tags                                = {}
  workload_identity_enabled           = false
  bootstrap_profile {
    artifact_source       = "Direct"
    container_registry_id = ""
  }
  default_node_pool {
    auto_scaling_enabled          = false
    capacity_reservation_group_id = ""
    fips_enabled                  = false
    gpu_driver                    = ""
    gpu_instance                  = ""
    host_encryption_enabled       = false
    host_group_id                 = ""
    kubelet_disk_type             = "OS"
    max_count                     = 0
    max_pods                      = 250
    min_count                     = 0
    name                          = "agentpool"
    node_count                    = 1
    node_labels                   = {}
    node_public_ip_enabled        = false
    node_public_ip_prefix_id      = ""
    only_critical_addons_enabled  = false
    orchestrator_version          = "1.35"
    os_disk_size_gb               = 128
    os_disk_type                  = "Managed"
    os_sku                        = "Ubuntu"
    pod_subnet_id                 = ""
    proximity_placement_group_id  = ""
    scale_down_mode               = "Delete"
    snapshot_id                   = ""
    tags                          = {}
    temporary_name_for_rotation   = ""
    type                          = "VirtualMachineScaleSets"
    ultra_ssd_enabled             = false
    vm_size                       = "Standard_D2s_v5"
    vnet_subnet_id                = ""
    workload_runtime              = ""
    zones                         = []
    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
      undrainable_node_behavior     = ""
    }
  }
  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }
  kubelet_identity {
    client_id                 = "a37aa05e-7d45-4a2a-bc03-a6bfc4e5171a"
    object_id                 = "3881ecbf-b46c-4a5b-a226-98e4fc5810de"
    user_assigned_identity_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MC_rg-ardl-7c2bfad159d510c2_aksb4ef4-7r_swedencentral/providers/Microsoft.ManagedIdentity/userAssignedIdentities/aksb4ef4-7r-agentpool"
  }
  network_profile {
    dns_service_ip      = "10.0.0.10"
    ip_versions         = ["IPv4"]
    load_balancer_sku   = "standard"
    network_data_plane  = "azure"
    network_mode        = ""
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = ""
    outbound_type       = "loadBalancer"
    pod_cidr            = "10.244.0.0/16"
    pod_cidrs           = ["10.244.0.0/16"]
    service_cidr        = "10.0.0.0/16"
    service_cidrs       = ["10.0.0.0/16"]
    load_balancer_profile {
      backend_pool_type           = "NodeIPConfiguration"
      idle_timeout_in_minutes     = 0
      managed_outbound_ip_count   = 1
      managed_outbound_ipv6_count = 0
      outbound_ip_address_ids     = []
      outbound_ip_prefix_ids      = []
      outbound_ports_allocated    = 0
    }
  }
  node_provisioning_profile {
    default_node_pools = ""
    mode               = "Manual"
  }
}
resource "azurerm_kubernetes_cluster_node_pool" "res-2" {
  auto_scaling_enabled          = false
  capacity_reservation_group_id = ""
  eviction_policy               = ""
  fips_enabled                  = false
  host_encryption_enabled       = false
  host_group_id                 = ""
  kubelet_disk_type             = "OS"
  kubernetes_cluster_id         = azurerm_kubernetes_cluster.res-1.id
  max_count                     = 0
  max_pods                      = 250
  min_count                     = 0
  mode                          = "System"
  name                          = "agentpool"
  node_count                    = 1
  node_labels                   = {}
  node_public_ip_enabled        = false
  node_public_ip_prefix_id      = ""
  node_taints                   = []
  orchestrator_version          = "1.35"
  os_disk_size_gb               = 128
  os_disk_type                  = "Managed"
  os_sku                        = "Ubuntu"
  os_type                       = "Linux"
  pod_subnet_id                 = ""
  priority                      = "Regular"
  proximity_placement_group_id  = ""
  scale_down_mode               = "Delete"
  spot_max_price                = -1
  tags                          = {}
  ultra_ssd_enabled             = false
  vm_size                       = "Standard_D2s_v5"
  vnet_subnet_id                = ""
  zones                         = []
  upgrade_settings {
    drain_timeout_in_minutes      = 0
    max_surge                     = "10%"
    max_unavailable               = ""
    node_soak_duration_in_minutes = 0
    undrainable_node_behavior     = ""
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7c2bfad159d510c2"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7c2bfad159d510c2/providers/Microsoft.ContainerService/managedClusters/aksb4ef4-7r"
  to = azurerm_kubernetes_cluster.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7c2bfad159d510c2/providers/Microsoft.ContainerService/managedClusters/aksb4ef4-7r/agentPools/agentpool"
  to = azurerm_kubernetes_cluster_node_pool.res-2
}
