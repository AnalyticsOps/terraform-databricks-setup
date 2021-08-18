terraform {
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.3.7"
    }
  }
}

variable "storage_account_name" {
  type = string
}

provider "databricks" {
  azure_workspace_resource_id = var.azurerm_databricks_workspace_id
  azure_client_id             = var.client_id
  azure_client_secret         = var.client_secret
  azure_tenant_id             = var.tenant_id
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

data "databricks_node_type" "smallest" {
  local_disk = false
}

resource "databricks_cluster" "cluster" {
  cluster_name            = "default_cluster"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 8
  }
}

resource "databricks_secret_scope" "this" {
  name = "terraform"
}

resource "databricks_secret" "this" {
  key          = "service_principal_key"
  string_value = var.client_secret
  scope        = databricks_secret_scope.this.name
}

# Disabled due to CCoE restriction
# resource "azurerm_role_assignment" "this" {
#   scope                = var.storage_account_id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = data.azurerm_client_config.current.object_id
#   depends_on = [azurerm_databricks_workspace.this]
# }

resource "databricks_azure_adls_gen2_mount" "this" {
  cluster_id             = databricks_cluster.cluster.id
  storage_account_name   = var.storage_account_name
  container_name         = "trainingdata"
  mount_name             = "data"
  tenant_id              = var.tenant_id
  client_id              = var.client_id
  client_secret_scope    = databricks_secret_scope.this.name
  client_secret_key      = databricks_secret.this.key
  initialize_file_system = true
}
