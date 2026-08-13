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
  name       = "rg-ardl-c7c28ed4cbde6a4b"
  tags = {
    armType    = "Microsoft.Web/sites"
    createdUtc = "2026-08-13T14:53:21.1286175Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_service_plan" "res-1" {
  app_service_environment_id      = ""
  location                        = "swedencentral"
  maximum_elastic_worker_count    = 1
  name                            = "planstn43n7m"
  os_type                         = "Linux"
  per_site_scaling_enabled        = false
  premium_plan_auto_scale_enabled = false
  resource_group_name             = azurerm_resource_group.res-0.name
  sku_name                        = "B1"
  tags                            = {}
  worker_count                    = 1
  zone_balancing_enabled          = false
}
resource "azurerm_linux_web_app" "res-2" {
  app_settings                                   = {}
  client_affinity_enabled                        = true
  client_certificate_enabled                     = false
  client_certificate_exclusion_paths             = ""
  client_certificate_mode                        = "Required"
  enabled                                        = true
  ftp_publish_basic_authentication_enabled       = true
  https_only                                     = true
  key_vault_reference_identity_id                = "SystemAssigned"
  location                                       = "swedencentral"
  name                                           = "appr2opwtix"
  public_network_access_enabled                  = true
  resource_group_name                            = azurerm_resource_group.res-0.name
  service_plan_id                                = azurerm_service_plan.res-1.id
  tags                                           = {}
  virtual_network_backup_restore_enabled         = false
  virtual_network_subnet_id                      = ""
  vnet_image_pull_enabled                        = false
  webdeploy_publish_basic_authentication_enabled = true
  zip_deploy_file                                = ""
  site_config {
    always_on                                     = false
    api_definition_url                            = ""
    api_management_api_id                         = ""
    app_command_line                              = ""
    container_registry_managed_identity_client_id = ""
    container_registry_use_managed_identity       = false
    default_documents                             = ["Default.htm", "Default.html", "Default.asp", "index.htm", "index.html", "iisstart.htm", "default.aspx", "index.php", "hostingstart.html"]
    ftps_state                                    = "FtpsOnly"
    health_check_eviction_time_in_min             = 0
    health_check_path                             = ""
    http2_enabled                                 = false
    ip_restriction_default_action                 = ""
    load_balancing_mode                           = "LeastRequests"
    local_mysql_enabled                           = false
    managed_pipeline_mode                         = "Integrated"
    minimum_tls_cipher_suite                      = ""
    minimum_tls_version                           = "1.2"
    remote_debugging_enabled                      = false
    remote_debugging_version                      = ""
    scm_ip_restriction_default_action             = ""
    scm_minimum_tls_version                       = "1.2"
    scm_use_main_ip_restriction                   = false
    use_32_bit_worker                             = true
    vnet_route_all_enabled                        = false
    websockets_enabled                            = false
    worker_count                                  = 1
    application_stack {
      docker_image_name        = ""
      docker_registry_password = "" # Masked sensitive attribute
      docker_registry_url      = ""
      docker_registry_username = ""
      dotnet_version           = ""
      go_version               = ""
      java_server              = ""
      java_server_version      = ""
      java_version             = ""
      node_version             = "20-lts"
      php_version              = ""
      python_version           = ""
      ruby_version             = ""
    }
  }
}
resource "azurerm_app_service_custom_hostname_binding" "res-6" {
  app_service_name    = "appr2opwtix"
  hostname            = "appr2opwtix.azurewebsites.net"
  resource_group_name = azurerm_resource_group.res-0.name
  ssl_state           = ""
  thumbprint          = ""
  depends_on = [
    azurerm_linux_web_app.res-2,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c7c28ed4cbde6a4b"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c7c28ed4cbde6a4b/providers/Microsoft.Web/serverFarms/planstn43n7m"
  to = azurerm_service_plan.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c7c28ed4cbde6a4b/providers/Microsoft.Web/sites/appr2opwtix"
  to = azurerm_linux_web_app.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c7c28ed4cbde6a4b/providers/Microsoft.Web/sites/appr2opwtix/hostNameBindings/appr2opwtix.azurewebsites.net"
  to = azurerm_app_service_custom_hostname_binding.res-6
}
