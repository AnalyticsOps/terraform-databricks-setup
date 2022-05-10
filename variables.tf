variable "azurerm_databricks_workspace_id" {
  type = string
}

variable "azurerm_databricks_workspace_url" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "tenant_id" {
  type = string
}

variable "storage_account_name" {
  type = string
}
