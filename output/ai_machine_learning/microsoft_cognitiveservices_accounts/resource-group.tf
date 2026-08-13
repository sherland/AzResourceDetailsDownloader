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
  name       = "rg-ardl-b1d8ed6affe79ba7"
  tags = {
    armType    = "Microsoft.CognitiveServices/accounts"
    createdUtc = "2026-08-13T13:02:21.7842160Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_cognitive_account" "res-1" {
  custom_question_answering_search_service_id  = ""
  custom_question_answering_search_service_key = "" # Masked sensitive attribute
  custom_subdomain_name                        = "ardlcog8l2-q-ck"
  dynamic_throttling_enabled                   = false
  fqdns                                        = []
  kind                                         = "CognitiveServices"
  local_auth_enabled                           = true
  location                                     = "norwayeast"
  metrics_advisor_aad_client_id                = ""
  metrics_advisor_aad_tenant_id                = ""
  metrics_advisor_super_user_name              = ""
  metrics_advisor_website_name                 = ""
  name                                         = "cogojuhykh8"
  outbound_network_access_restricted           = false
  project_management_enabled                   = false
  public_network_access_enabled                = true
  qna_runtime_endpoint                         = ""
  resource_group_name                          = azurerm_resource_group.res-0.name
  sku_name                                     = "S0"
  tags                                         = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b1d8ed6affe79ba7"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b1d8ed6affe79ba7/providers/Microsoft.CognitiveServices/accounts/cogojuhykh8"
  to = azurerm_cognitive_account.res-1
}
