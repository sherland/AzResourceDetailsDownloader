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
  name       = "rg-ardl-c966974de34ce9d7"
  tags = {
    armType    = "Microsoft.Compute/sshPublicKeys"
    createdUtc = "2026-07-15T18:34:49.0798720Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_ssh_public_key" "res-1" {
  location            = "westeurope"
  name                = "sshkey89-8y7sp"
  public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMf4Pa+FlecNaDqyuITzNaZErfcsxCCRt5SGvBMi7+xZc6A87B+uo4bdYyrKVS+pfdHXUtOkGn7IYj/UMqx8V2QVni32cUQa08zxj1d9Hv9yT2P+2apXNbEAfZ2gKtcFj4HgtXMR+gtCG5IOu16c8MsPytK52qgfYcw6L2AwhYCV3bNuEBW/cLEA8Kh9FmdCEkp0QWOXlwVq6XO7w01ORLtpZMx9+urnzq8s0uUcgSolVynmMTWeNMhJbQPu1iKygYU4dl+YSE+dKXqm863CQBvnpcmeRcIVHsCVBqV82mpF1mMGa0xqUA45Hu4FLuNVHJWYuJN5IuFwFBpjQDuRqH ardl@example.com"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c966974de34ce9d7"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c966974de34ce9d7/providers/Microsoft.Compute/sshPublicKeys/sshkey89-8y7sp"
  to = azurerm_ssh_public_key.res-1
}
