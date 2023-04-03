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
  features {}
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

resource "azurerm_storage_container" "program_storage_container" {
  provider              = azurerm
  name                  = var.program_name
  storage_account_name  = "swordfish${var.center_name}"
  container_access_type = "private"
}
