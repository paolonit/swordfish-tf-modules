data "azuread_client_config" "current" {}

variable "center_name" {
  type        = string
  description = "The name of the program being onboarded."
  nullable = false
}

variable "program_name" {
  type        = string
  description = "The name of the program being onboarded."
  nullable = false
}

resource "azuread_group" "program_aad_group" {
  display_name     = var.program_name
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

resource "azurerm_storage_container" "program_storage_container" {
  name                  = var.program_name
  storage_account_name  = "swordfish${var.center_name}"
  container_access_type = "private"
}
