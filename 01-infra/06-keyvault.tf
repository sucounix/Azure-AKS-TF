data "azurerm_client_config" "current" {
}
resource "azurerm_key_vault" "kv" {
  name                        = "${lower(var.company)}-${var.environment}-kv"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.aks_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = var.sku_name
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = var.key_permissions
    secret_permissions = var.secret_permissions
    storage_permissions = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
  }
    depends_on = [
    azurerm_kubernetes_cluster.aks_cluster
  ]
}
