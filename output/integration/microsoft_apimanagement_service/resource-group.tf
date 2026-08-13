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
  name       = "rg-ardl-4f4d76db12ba6ca3"
  tags = {
    armType    = "Microsoft.ApiManagement/service"
    createdUtc = "2026-08-13T14:36:15.7041744Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_api_management" "res-1" {
  client_certificate_enabled    = false
  gateway_disabled              = false
  location                      = "norwayeast"
  min_api_version               = ""
  name                          = "apimaib-5hed"
  notification_sender_email     = "apimgmt-noreply@mail.windowsazure.com"
  public_ip_address_id          = ""
  public_network_access_enabled = true
  publisher_email               = "ardl@example.com"
  publisher_name                = "ARDL"
  resource_group_name           = azurerm_resource_group.res-0.name
  sku_name                      = "Consumption_0"
  tags                          = {}
  virtual_network_type          = "None"
  zones                         = []
  hostname_configuration {
    proxy {
      certificate                     = "" # Masked sensitive attribute
      certificate_password            = "" # Masked sensitive attribute
      default_ssl_binding             = true
      host_name                       = "apimaib-5hed.azure-api.net"
      key_vault_certificate_id        = ""
      key_vault_id                    = ""
      negotiate_client_certificate    = false
      ssl_keyvault_identity_client_id = ""
    }
  }
  protocols {
    enable_http2  = false
    http2_enabled = false
  }
  security {
    backend_ssl30_enabled                               = false
    backend_tls10_enabled                               = false
    backend_tls11_enabled                               = false
    enable_backend_ssl30                                = false
    enable_backend_tls10                                = false
    enable_backend_tls11                                = false
    enable_frontend_ssl30                               = false
    enable_frontend_tls10                               = false
    enable_frontend_tls11                               = false
    frontend_ssl30_enabled                              = false
    frontend_tls10_enabled                              = false
    frontend_tls11_enabled                              = false
    tls_ecdhe_ecdsa_with_aes128_cbc_sha_ciphers_enabled = false
    tls_ecdhe_ecdsa_with_aes256_cbc_sha_ciphers_enabled = false
    tls_ecdhe_rsa_with_aes128_cbc_sha_ciphers_enabled   = false
    tls_ecdhe_rsa_with_aes256_cbc_sha_ciphers_enabled   = false
    tls_rsa_with_aes128_cbc_sha256_ciphers_enabled      = false
    tls_rsa_with_aes128_cbc_sha_ciphers_enabled         = false
    tls_rsa_with_aes128_gcm_sha256_ciphers_enabled      = false
    tls_rsa_with_aes256_cbc_sha256_ciphers_enabled      = false
    tls_rsa_with_aes256_cbc_sha_ciphers_enabled         = false
    tls_rsa_with_aes256_gcm_sha384_ciphers_enabled      = false
    triple_des_ciphers_enabled                          = false
  }
}
resource "azurerm_api_management_policy" "res-2" {
  api_management_id = azurerm_api_management.res-1.id
  xml_content       = "<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - Only the <forward-request> policy element can appear within the <backend> section element.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy position the cursor at the desired insertion point and click on the round button associated with the policy.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n-->\r\n<policies>\r\n\t<inbound></inbound>\r\n\t<backend>\r\n\t\t<forward-request />\r\n\t</backend>\r\n\t<outbound></outbound>\r\n</policies>"
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-4f4d76db12ba6ca3"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-4f4d76db12ba6ca3/providers/Microsoft.ApiManagement/service/apimaib-5hed"
  to = azurerm_api_management.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-4f4d76db12ba6ca3/providers/Microsoft.ApiManagement/service/apimaib-5hed"
  to = azurerm_api_management_policy.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-4f4d76db12ba6ca3/providers/Microsoft.ApiManagement/service/apimaib-5hed/subscriptions/master"
  to = azurerm_api_management_subscription.res-3
}
