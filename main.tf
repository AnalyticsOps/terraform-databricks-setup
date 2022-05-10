terraform {
  required_providers {
    databricks = {
      source  = "databrickslabs/databricks"
      version = "0.3.7"
    }
  }
}


provider "databricks" {
  azure_workspace_resource_id = var.azurerm_databricks_workspace_id
  azure_client_id             = var.client_id
  azure_client_secret         = var.client_secret
  azure_tenant_id             = var.tenant_id
}

# resource "databricks_notebook" "ddl" {
#   content_base64 = base64encode(<<-EOT
#     config = {
#       "fs.azure.account.auth.type": "CustomAccessToken",
#       "fs.azure.account.custom.token.provider.class": spark.conf.get("spark.databricks.passthrough.adls.gen2.tokenProviderClassName")
#     }

#     dbutils.fs.mount(
#       source = "abfss://datasets@dpcontentstorageprod.dfs.core.windows.net",
#       mount_point = "/mnt/dataplatform",
#       extra_configs = config
#     )

#     dbutils.fs.mount(
#       source = "abfss://data@${var.storage_account_name}.dfs.core.windows.net",
#       mount_point = "/mnt/data",
#       extra_configs = config
#     )
#     EOT
#   )
#   path = "/Shared/Mount"
#   language = "PYTHON"

#   depends_on = [
#     var.azurerm_databricks_workspace_id
#   ]
# }
