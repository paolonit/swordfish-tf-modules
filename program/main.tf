terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.36.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.50.0"
    }
  }
}

provider "azuread" {
}

provider "azurerm" {
  features {}
}

data "azuread_client_config" "current" {
  provider = azuread
}

variable "center_name" {
  type        = string
  description = "The name of the program being onboarded."
  nullable    = false
}

variable "program_name" {
  type        = string
  description = "The name of the program being onboarded."
  nullable    = false
}

resource "azuread_group" "program_aad_group" {
  provider         = azuread
  display_name     = var.program_name
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

resource "azurerm_storage_data_lake_gen2_filesystem" "program_storage_container" {
  provider              = azurerm
  name                  = var.program_name
  storage_account_id  = "/subscriptions/df0394a0-26f7-4700-9fbb-5d0df992d9de/resourceGroups/rg-dev/providers/Microsoft.Storage/storageAccounts/swordfish${var.center_name}"
  container_access_type = "private"
}

resource "azurerm_role_assignment" "program_storage_container_role_assignment" {
  provider              = azurerm
  scope                = resource.azurerm_storage_container.program_storage_container.resource_manager_id
  role_definition_name = "Contributor"
  principal_id         = resource.azuread_group.program_aad_group.object_id
}
