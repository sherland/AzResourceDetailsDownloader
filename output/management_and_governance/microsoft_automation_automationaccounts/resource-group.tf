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
  name       = "rg-ardl-7ab2ffe44d702d19"
  tags = {
    armType    = "Microsoft.Automation/automationAccounts"
    createdUtc = "2026-07-15T18:28:12.2758025Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_automation_connection_type" "res-2" {
  automation_account_name = "aa8ln-7a5l"
  is_global               = true
  name                    = "Azure"
  resource_group_name     = azurerm_resource_group.res-0.name
  field {
    is_encrypted = false
    is_optional  = false
    name         = "AutomationCertificateName"
    type         = "System.String"
  }
  field {
    is_encrypted = false
    is_optional  = false
    name         = "SubscriptionID"
    type         = "System.String"
  }
}
resource "azurerm_automation_connection_type" "res-3" {
  automation_account_name = "aa8ln-7a5l"
  is_global               = true
  name                    = "AzureClassicCertificate"
  resource_group_name     = azurerm_resource_group.res-0.name
  field {
    is_encrypted = false
    is_optional  = false
    name         = "SubscriptionName"
    type         = "System.String"
  }
  field {
    is_encrypted = false
    is_optional  = false
    name         = "SubscriptionId"
    type         = "System.String"
  }
  field {
    is_encrypted = false
    is_optional  = false
    name         = "CertificateAssetName"
    type         = "System.String"
  }
}
resource "azurerm_automation_connection_type" "res-4" {
  automation_account_name = "aa8ln-7a5l"
  is_global               = true
  name                    = "AzureServicePrincipal"
  resource_group_name     = azurerm_resource_group.res-0.name
  field {
    is_encrypted = false
    is_optional  = false
    name         = "CertificateThumbprint"
    type         = "System.String"
  }
  field {
    is_encrypted = false
    is_optional  = false
    name         = "SubscriptionId"
    type         = "System.String"
  }
  field {
    is_encrypted = false
    is_optional  = false
    name         = "ApplicationId"
    type         = "System.String"
  }
  field {
    is_encrypted = false
    is_optional  = false
    name         = "TenantId"
    type         = "System.String"
  }
}
resource "azurerm_automation_module" "res-5" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "AuditPolicyDsc"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-6" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-7" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Accounts"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-8" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Advisor"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-9" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Aks"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-10" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.AnalysisServices"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-11" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.ApiManagement"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-12" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.App"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-13" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.AppConfiguration"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-14" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.ApplicationInsights"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-15" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.ArcResourceBridge"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-16" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Attestation"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-17" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Automanage"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-18" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Automation"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-19" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Batch"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-20" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Billing"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-21" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Cdn"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-22" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.CloudService"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-23" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.CognitiveServices"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-24" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Compute"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-25" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.ConfidentialLedger"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-26" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.ContainerInstance"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-27" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.ContainerRegistry"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-28" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.CosmosDB"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-29" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.DataBoxEdge"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-30" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.DataFactory"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-31" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.DataLakeAnalytics"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-32" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.DataLakeStore"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-33" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.DataProtection"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-34" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.DataShare"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-35" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Databricks"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-36" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.DeploymentManager"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-37" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.DesktopVirtualization"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-38" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.DevCenter"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-39" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.DevTestLabs"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-40" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Dns"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-41" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.EventGrid"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-42" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.EventHub"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-43" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.FrontDoor"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-44" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Functions"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-45" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.HDInsight"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-46" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.HealthcareApis"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-47" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.IotHub"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-48" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.KeyVault"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-49" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Kusto"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-50" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.LoadTesting"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-51" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.LogicApp"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-52" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.MachineLearning"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-53" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.MachineLearningServices"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-54" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Maintenance"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-55" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.ManagedServiceIdentity"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-56" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.ManagedServices"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-57" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.MarketplaceOrdering"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-58" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Media"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-59" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Migrate"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-60" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Monitor"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-61" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.MySql"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-62" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Network"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-63" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.NetworkCloud"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-64" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.NotificationHubs"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-65" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.OperationalInsights"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-66" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.PolicyInsights"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-67" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.PostgreSql"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-68" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.PowerBIEmbedded"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-69" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.PrivateDns"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-70" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.RecoveryServices"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-71" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.RedisCache"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-72" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.RedisEnterpriseCache"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-73" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Relay"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-74" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.ResourceMover"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-75" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Resources"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-76" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Security"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-77" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.SecurityInsights"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-78" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.ServiceBus"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-79" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.ServiceFabric"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-80" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.SignalR"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-81" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Sql"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-82" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.SqlVirtualMachine"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-83" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.StackHCI"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-84" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Storage"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-85" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.StorageMover"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-86" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.StorageSync"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-87" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.StreamAnalytics"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-88" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Support"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-89" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Synapse"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-90" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.TrafficManager"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-91" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Az.Websites"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-92" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Azure"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-93" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Azure.Storage"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-94" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "AzureRM.Automation"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-95" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "AzureRM.Compute"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-96" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "AzureRM.Profile"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-97" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "AzureRM.Resources"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-98" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "AzureRM.Sql"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-99" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "AzureRM.Storage"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-100" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "ComputerManagementDsc"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-101" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "GPRegistryPolicyParser"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-102" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Microsoft.PowerShell.Core"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-103" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Microsoft.PowerShell.Diagnostics"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-104" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Microsoft.PowerShell.Management"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-105" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Microsoft.PowerShell.Security"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-106" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Microsoft.PowerShell.Utility"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-107" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Microsoft.WSMan.Management"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-108" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "Orchestrator.AssetManagement.Cmdlets"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-109" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "PSDscResources"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-110" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "SecurityPolicyDsc"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-111" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "StateConfigCompositeResources"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-112" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "xDSCDomainjoin"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-113" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "xPowerShellExecutionPolicy"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_module" "res-114" {
  automation_account_name = "aa8ln-7a5l"
  name                    = "xRemoteDesktopAdmin"
  resource_group_name     = azurerm_resource_group.res-0.name
}
resource "azurerm_automation_powershell72_module" "res-115" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-116" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Accounts"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-117" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Advisor"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-118" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Aks"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-119" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.AnalysisServices"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-120" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.ApiManagement"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-121" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.App"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-122" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.AppConfiguration"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-123" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.ApplicationInsights"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-124" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.ArcResourceBridge"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-125" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Attestation"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-126" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Automanage"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-127" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Automation"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-128" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Batch"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-129" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Billing"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-130" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Cdn"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-131" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.CloudService"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-132" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.CognitiveServices"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-133" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Compute"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-134" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.ConfidentialLedger"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-135" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.ContainerInstance"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-136" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.ContainerRegistry"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-137" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.CosmosDB"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-138" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.DataBoxEdge"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-139" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.DataFactory"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-140" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.DataLakeAnalytics"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-141" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.DataLakeStore"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-142" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.DataProtection"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-143" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.DataShare"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-144" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Databricks"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-145" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.DeploymentManager"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-146" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.DesktopVirtualization"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-147" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.DevCenter"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-148" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.DevTestLabs"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-149" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Dns"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-150" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.EventGrid"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-151" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.EventHub"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-152" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.FrontDoor"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-153" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Functions"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-154" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.HDInsight"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-155" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.HealthcareApis"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-156" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.IotHub"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-157" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.KeyVault"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-158" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Kusto"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-159" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.LoadTesting"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-160" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.LogicApp"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-161" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.MachineLearning"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-162" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.MachineLearningServices"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-163" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Maintenance"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-164" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.ManagedServiceIdentity"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-165" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.ManagedServices"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-166" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.MarketplaceOrdering"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-167" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Media"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-168" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Migrate"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-169" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Monitor"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-170" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.MySql"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-171" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Network"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-172" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.NetworkCloud"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-173" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.NotificationHubs"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-174" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.OperationalInsights"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-175" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.PolicyInsights"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-176" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.PostgreSql"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-177" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.PowerBIEmbedded"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-178" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.PrivateDns"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-179" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.RecoveryServices"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-180" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.RedisCache"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-181" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.RedisEnterpriseCache"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-182" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Relay"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-183" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.ResourceMover"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-184" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Resources"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-185" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Security"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-186" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.SecurityInsights"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-187" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.ServiceBus"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-188" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.ServiceFabric"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-189" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.SignalR"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-190" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Sql"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-191" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.SqlVirtualMachine"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-192" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.StackHCI"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-193" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Storage"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-194" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.StorageMover"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-195" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.StorageSync"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-196" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.StreamAnalytics"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-197" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Support"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-198" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Synapse"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-199" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.TrafficManager"
  tags                  = {}
}
resource "azurerm_automation_powershell72_module" "res-200" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  name                  = "Az.Websites"
  tags                  = {}
}
resource "azurerm_automation_runtime_environment" "res-201" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  description           = "System-generated Runtime Environment for your Automation account with Runtime language: PowerShell & Runtime version: 5.1. It automatically populates Packages defined for PowerShell 5.1 runtime version in your Automation account. This Runtime environment is non-editable. "
  location              = "westeurope"
  name                  = "PowerShell-5.1"
  runtime_default_packages = {
    az = "11.2.0"
  }
  runtime_language = "PowerShell"
  runtime_version  = "5.1"
  tags             = {}
}
resource "azurerm_automation_runtime_environment" "res-226" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  description           = "System-generated Runtime Environment for your Automation account with Runtime language: PowerShell & Runtime version: 7.1. It automatically populates Packages defined for PowerShell 7.1 runtime version in your Automation account. This Runtime environment is non-editable. "
  location              = "westeurope"
  name                  = "PowerShell-7.1"
  runtime_default_packages = {
    az = "8.0.0"
  }
  runtime_language = "PowerShell"
  runtime_version  = "7.1"
  tags             = {}
}
resource "azurerm_automation_runtime_environment" "res-228" {
  automation_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  description           = "System-generated Runtime Environment for your Automation account with Runtime language: PowerShell & Runtime version: 7.2. It automatically populates Packages defined for PowerShell 7.2 runtime version in your Automation account. This Runtime environment is non-editable. "
  location              = "westeurope"
  name                  = "PowerShell-7.2"
  runtime_default_packages = {
    az          = "11.2.0"
    "azure cli" = "2.56.0"
  }
  runtime_language = "PowerShell"
  runtime_version  = "7.2"
  tags             = {}
}
resource "azurerm_automation_runtime_environment" "res-229" {
  automation_account_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  description              = "System-generated Runtime Environment for your Automation account with Runtime language: Python & Runtime version: 2.7. It automatically populates Packages defined for Python 2.7 runtime version in your Automation account. This Runtime environment is non-editable. "
  location                 = "westeurope"
  name                     = "Python-2.7"
  runtime_default_packages = {}
  runtime_language         = "Python"
  runtime_version          = "2.7"
  tags                     = {}
}
resource "azurerm_automation_runtime_environment" "res-230" {
  automation_account_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  description              = "System-generated Runtime Environment for your Automation account with Runtime language: Python & Runtime version: 3.10. It automatically populates Packages defined for Python 3.10 runtime version in your Automation account. This Runtime environment is non-editable. "
  location                 = "westeurope"
  name                     = "Python-3.10"
  runtime_default_packages = {}
  runtime_language         = "Python"
  runtime_version          = "3.10"
  tags                     = {}
}
resource "azurerm_automation_runtime_environment" "res-231" {
  automation_account_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  description              = "System-generated Runtime Environment for your Automation account with Runtime language: Python & Runtime version: 3.8. It automatically populates Packages defined for Python 3.8 runtime version in your Automation account. This Runtime environment is non-editable. "
  location                 = "westeurope"
  name                     = "Python-3.8"
  runtime_default_packages = {}
  runtime_language         = "Python"
  runtime_version          = "3.8"
  tags                     = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l"
  to = azurerm_automation_account.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/connectionTypes/Azure"
  to = azurerm_automation_connection_type.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/connectionTypes/AzureClassicCertificate"
  to = azurerm_automation_connection_type.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/connectionTypes/AzureServicePrincipal"
  to = azurerm_automation_connection_type.res-4
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/AuditPolicyDsc"
  to = azurerm_automation_module.res-5
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az"
  to = azurerm_automation_module.res-6
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Accounts"
  to = azurerm_automation_module.res-7
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Advisor"
  to = azurerm_automation_module.res-8
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Aks"
  to = azurerm_automation_module.res-9
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.AnalysisServices"
  to = azurerm_automation_module.res-10
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.ApiManagement"
  to = azurerm_automation_module.res-11
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.App"
  to = azurerm_automation_module.res-12
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.AppConfiguration"
  to = azurerm_automation_module.res-13
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.ApplicationInsights"
  to = azurerm_automation_module.res-14
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.ArcResourceBridge"
  to = azurerm_automation_module.res-15
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Attestation"
  to = azurerm_automation_module.res-16
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Automanage"
  to = azurerm_automation_module.res-17
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Automation"
  to = azurerm_automation_module.res-18
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Batch"
  to = azurerm_automation_module.res-19
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Billing"
  to = azurerm_automation_module.res-20
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Cdn"
  to = azurerm_automation_module.res-21
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.CloudService"
  to = azurerm_automation_module.res-22
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.CognitiveServices"
  to = azurerm_automation_module.res-23
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Compute"
  to = azurerm_automation_module.res-24
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.ConfidentialLedger"
  to = azurerm_automation_module.res-25
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.ContainerInstance"
  to = azurerm_automation_module.res-26
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.ContainerRegistry"
  to = azurerm_automation_module.res-27
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.CosmosDB"
  to = azurerm_automation_module.res-28
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.DataBoxEdge"
  to = azurerm_automation_module.res-29
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.DataFactory"
  to = azurerm_automation_module.res-30
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.DataLakeAnalytics"
  to = azurerm_automation_module.res-31
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.DataLakeStore"
  to = azurerm_automation_module.res-32
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.DataProtection"
  to = azurerm_automation_module.res-33
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.DataShare"
  to = azurerm_automation_module.res-34
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Databricks"
  to = azurerm_automation_module.res-35
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.DeploymentManager"
  to = azurerm_automation_module.res-36
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.DesktopVirtualization"
  to = azurerm_automation_module.res-37
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.DevCenter"
  to = azurerm_automation_module.res-38
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.DevTestLabs"
  to = azurerm_automation_module.res-39
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Dns"
  to = azurerm_automation_module.res-40
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.EventGrid"
  to = azurerm_automation_module.res-41
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.EventHub"
  to = azurerm_automation_module.res-42
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.FrontDoor"
  to = azurerm_automation_module.res-43
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Functions"
  to = azurerm_automation_module.res-44
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.HDInsight"
  to = azurerm_automation_module.res-45
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.HealthcareApis"
  to = azurerm_automation_module.res-46
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.IotHub"
  to = azurerm_automation_module.res-47
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.KeyVault"
  to = azurerm_automation_module.res-48
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Kusto"
  to = azurerm_automation_module.res-49
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.LoadTesting"
  to = azurerm_automation_module.res-50
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.LogicApp"
  to = azurerm_automation_module.res-51
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.MachineLearning"
  to = azurerm_automation_module.res-52
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.MachineLearningServices"
  to = azurerm_automation_module.res-53
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Maintenance"
  to = azurerm_automation_module.res-54
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.ManagedServiceIdentity"
  to = azurerm_automation_module.res-55
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.ManagedServices"
  to = azurerm_automation_module.res-56
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.MarketplaceOrdering"
  to = azurerm_automation_module.res-57
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Media"
  to = azurerm_automation_module.res-58
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Migrate"
  to = azurerm_automation_module.res-59
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Monitor"
  to = azurerm_automation_module.res-60
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.MySql"
  to = azurerm_automation_module.res-61
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Network"
  to = azurerm_automation_module.res-62
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.NetworkCloud"
  to = azurerm_automation_module.res-63
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.NotificationHubs"
  to = azurerm_automation_module.res-64
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.OperationalInsights"
  to = azurerm_automation_module.res-65
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.PolicyInsights"
  to = azurerm_automation_module.res-66
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.PostgreSql"
  to = azurerm_automation_module.res-67
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.PowerBIEmbedded"
  to = azurerm_automation_module.res-68
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.PrivateDns"
  to = azurerm_automation_module.res-69
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.RecoveryServices"
  to = azurerm_automation_module.res-70
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.RedisCache"
  to = azurerm_automation_module.res-71
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.RedisEnterpriseCache"
  to = azurerm_automation_module.res-72
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Relay"
  to = azurerm_automation_module.res-73
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.ResourceMover"
  to = azurerm_automation_module.res-74
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Resources"
  to = azurerm_automation_module.res-75
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Security"
  to = azurerm_automation_module.res-76
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.SecurityInsights"
  to = azurerm_automation_module.res-77
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.ServiceBus"
  to = azurerm_automation_module.res-78
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.ServiceFabric"
  to = azurerm_automation_module.res-79
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.SignalR"
  to = azurerm_automation_module.res-80
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Sql"
  to = azurerm_automation_module.res-81
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.SqlVirtualMachine"
  to = azurerm_automation_module.res-82
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.StackHCI"
  to = azurerm_automation_module.res-83
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Storage"
  to = azurerm_automation_module.res-84
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.StorageMover"
  to = azurerm_automation_module.res-85
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.StorageSync"
  to = azurerm_automation_module.res-86
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.StreamAnalytics"
  to = azurerm_automation_module.res-87
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Support"
  to = azurerm_automation_module.res-88
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Synapse"
  to = azurerm_automation_module.res-89
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.TrafficManager"
  to = azurerm_automation_module.res-90
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Az.Websites"
  to = azurerm_automation_module.res-91
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Azure"
  to = azurerm_automation_module.res-92
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Azure.Storage"
  to = azurerm_automation_module.res-93
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/AzureRM.Automation"
  to = azurerm_automation_module.res-94
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/AzureRM.Compute"
  to = azurerm_automation_module.res-95
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/AzureRM.Profile"
  to = azurerm_automation_module.res-96
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/AzureRM.Resources"
  to = azurerm_automation_module.res-97
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/AzureRM.Sql"
  to = azurerm_automation_module.res-98
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/AzureRM.Storage"
  to = azurerm_automation_module.res-99
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/ComputerManagementDsc"
  to = azurerm_automation_module.res-100
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/GPRegistryPolicyParser"
  to = azurerm_automation_module.res-101
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Microsoft.PowerShell.Core"
  to = azurerm_automation_module.res-102
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Microsoft.PowerShell.Diagnostics"
  to = azurerm_automation_module.res-103
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Microsoft.PowerShell.Management"
  to = azurerm_automation_module.res-104
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Microsoft.PowerShell.Security"
  to = azurerm_automation_module.res-105
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Microsoft.PowerShell.Utility"
  to = azurerm_automation_module.res-106
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Microsoft.WSMan.Management"
  to = azurerm_automation_module.res-107
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/Orchestrator.AssetManagement.Cmdlets"
  to = azurerm_automation_module.res-108
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/PSDscResources"
  to = azurerm_automation_module.res-109
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/SecurityPolicyDsc"
  to = azurerm_automation_module.res-110
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/StateConfigCompositeResources"
  to = azurerm_automation_module.res-111
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/xDSCDomainjoin"
  to = azurerm_automation_module.res-112
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/xPowerShellExecutionPolicy"
  to = azurerm_automation_module.res-113
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/modules/xRemoteDesktopAdmin"
  to = azurerm_automation_module.res-114
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az"
  to = azurerm_automation_powershell72_module.res-115
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Accounts"
  to = azurerm_automation_powershell72_module.res-116
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Advisor"
  to = azurerm_automation_powershell72_module.res-117
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Aks"
  to = azurerm_automation_powershell72_module.res-118
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.AnalysisServices"
  to = azurerm_automation_powershell72_module.res-119
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.ApiManagement"
  to = azurerm_automation_powershell72_module.res-120
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.App"
  to = azurerm_automation_powershell72_module.res-121
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.AppConfiguration"
  to = azurerm_automation_powershell72_module.res-122
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.ApplicationInsights"
  to = azurerm_automation_powershell72_module.res-123
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.ArcResourceBridge"
  to = azurerm_automation_powershell72_module.res-124
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Attestation"
  to = azurerm_automation_powershell72_module.res-125
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Automanage"
  to = azurerm_automation_powershell72_module.res-126
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Automation"
  to = azurerm_automation_powershell72_module.res-127
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Batch"
  to = azurerm_automation_powershell72_module.res-128
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Billing"
  to = azurerm_automation_powershell72_module.res-129
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Cdn"
  to = azurerm_automation_powershell72_module.res-130
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.CloudService"
  to = azurerm_automation_powershell72_module.res-131
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.CognitiveServices"
  to = azurerm_automation_powershell72_module.res-132
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Compute"
  to = azurerm_automation_powershell72_module.res-133
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.ConfidentialLedger"
  to = azurerm_automation_powershell72_module.res-134
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.ContainerInstance"
  to = azurerm_automation_powershell72_module.res-135
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.ContainerRegistry"
  to = azurerm_automation_powershell72_module.res-136
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.CosmosDB"
  to = azurerm_automation_powershell72_module.res-137
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.DataBoxEdge"
  to = azurerm_automation_powershell72_module.res-138
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.DataFactory"
  to = azurerm_automation_powershell72_module.res-139
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.DataLakeAnalytics"
  to = azurerm_automation_powershell72_module.res-140
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.DataLakeStore"
  to = azurerm_automation_powershell72_module.res-141
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.DataProtection"
  to = azurerm_automation_powershell72_module.res-142
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.DataShare"
  to = azurerm_automation_powershell72_module.res-143
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Databricks"
  to = azurerm_automation_powershell72_module.res-144
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.DeploymentManager"
  to = azurerm_automation_powershell72_module.res-145
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.DesktopVirtualization"
  to = azurerm_automation_powershell72_module.res-146
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.DevCenter"
  to = azurerm_automation_powershell72_module.res-147
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.DevTestLabs"
  to = azurerm_automation_powershell72_module.res-148
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Dns"
  to = azurerm_automation_powershell72_module.res-149
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.EventGrid"
  to = azurerm_automation_powershell72_module.res-150
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.EventHub"
  to = azurerm_automation_powershell72_module.res-151
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.FrontDoor"
  to = azurerm_automation_powershell72_module.res-152
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Functions"
  to = azurerm_automation_powershell72_module.res-153
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.HDInsight"
  to = azurerm_automation_powershell72_module.res-154
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.HealthcareApis"
  to = azurerm_automation_powershell72_module.res-155
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.IotHub"
  to = azurerm_automation_powershell72_module.res-156
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.KeyVault"
  to = azurerm_automation_powershell72_module.res-157
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Kusto"
  to = azurerm_automation_powershell72_module.res-158
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.LoadTesting"
  to = azurerm_automation_powershell72_module.res-159
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.LogicApp"
  to = azurerm_automation_powershell72_module.res-160
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.MachineLearning"
  to = azurerm_automation_powershell72_module.res-161
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.MachineLearningServices"
  to = azurerm_automation_powershell72_module.res-162
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Maintenance"
  to = azurerm_automation_powershell72_module.res-163
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.ManagedServiceIdentity"
  to = azurerm_automation_powershell72_module.res-164
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.ManagedServices"
  to = azurerm_automation_powershell72_module.res-165
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.MarketplaceOrdering"
  to = azurerm_automation_powershell72_module.res-166
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Media"
  to = azurerm_automation_powershell72_module.res-167
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Migrate"
  to = azurerm_automation_powershell72_module.res-168
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Monitor"
  to = azurerm_automation_powershell72_module.res-169
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.MySql"
  to = azurerm_automation_powershell72_module.res-170
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Network"
  to = azurerm_automation_powershell72_module.res-171
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.NetworkCloud"
  to = azurerm_automation_powershell72_module.res-172
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.NotificationHubs"
  to = azurerm_automation_powershell72_module.res-173
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.OperationalInsights"
  to = azurerm_automation_powershell72_module.res-174
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.PolicyInsights"
  to = azurerm_automation_powershell72_module.res-175
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.PostgreSql"
  to = azurerm_automation_powershell72_module.res-176
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.PowerBIEmbedded"
  to = azurerm_automation_powershell72_module.res-177
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.PrivateDns"
  to = azurerm_automation_powershell72_module.res-178
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.RecoveryServices"
  to = azurerm_automation_powershell72_module.res-179
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.RedisCache"
  to = azurerm_automation_powershell72_module.res-180
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.RedisEnterpriseCache"
  to = azurerm_automation_powershell72_module.res-181
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Relay"
  to = azurerm_automation_powershell72_module.res-182
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.ResourceMover"
  to = azurerm_automation_powershell72_module.res-183
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Resources"
  to = azurerm_automation_powershell72_module.res-184
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Security"
  to = azurerm_automation_powershell72_module.res-185
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.SecurityInsights"
  to = azurerm_automation_powershell72_module.res-186
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.ServiceBus"
  to = azurerm_automation_powershell72_module.res-187
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.ServiceFabric"
  to = azurerm_automation_powershell72_module.res-188
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.SignalR"
  to = azurerm_automation_powershell72_module.res-189
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Sql"
  to = azurerm_automation_powershell72_module.res-190
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.SqlVirtualMachine"
  to = azurerm_automation_powershell72_module.res-191
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.StackHCI"
  to = azurerm_automation_powershell72_module.res-192
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Storage"
  to = azurerm_automation_powershell72_module.res-193
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.StorageMover"
  to = azurerm_automation_powershell72_module.res-194
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.StorageSync"
  to = azurerm_automation_powershell72_module.res-195
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.StreamAnalytics"
  to = azurerm_automation_powershell72_module.res-196
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Support"
  to = azurerm_automation_powershell72_module.res-197
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Synapse"
  to = azurerm_automation_powershell72_module.res-198
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.TrafficManager"
  to = azurerm_automation_powershell72_module.res-199
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/powerShell72Modules/Az.Websites"
  to = azurerm_automation_powershell72_module.res-200
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/runtimeEnvironments/PowerShell-5.1"
  to = azurerm_automation_runtime_environment.res-201
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/runtimeEnvironments/PowerShell-7.1"
  to = azurerm_automation_runtime_environment.res-226
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/runtimeEnvironments/PowerShell-7.2"
  to = azurerm_automation_runtime_environment.res-228
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/runtimeEnvironments/Python-2.7"
  to = azurerm_automation_runtime_environment.res-229
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/runtimeEnvironments/Python-3.10"
  to = azurerm_automation_runtime_environment.res-230
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-7ab2ffe44d702d19/providers/Microsoft.Automation/automationAccounts/aa8ln-7a5l/runtimeEnvironments/Python-3.8"
  to = azurerm_automation_runtime_environment.res-231
}
