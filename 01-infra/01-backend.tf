#####################################################################
#
#
# Storage Backend Configuration File
#
#
# /*

# Create a Resource Group for the Terraform State File
resource "azurerm_resource_group" "state-rg" {
  name          = "${lower(var.company)}-${var.environment}-tfstate-rg"
  location      = var.location

  lifecycle {
    prevent_destroy = true
  }
  tags = {
    environment = var.environment
  }
}

# Create a Storage Account for the Terraform State File
resource "azurerm_storage_account" "state-sta" {
  depends_on          = [azurerm_resource_group.state-rg]
  name                = var.az-storage-account
  resource_group_name = azurerm_resource_group.state-rg.name
  location            = azurerm_resource_group.state-rg.location
  account_kind        = "StorageV2"
  account_tier        = "Standard"
  access_tier         = "Hot"
  account_replication_type  = "ZRS"
  enable_https_traffic_only = true

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    environment = var.environment
  }
}

# Create a Storage Container for the Core State File
resource "azurerm_storage_container" "core-container" {
  depends_on           = [azurerm_storage_account.state-sta]
  name                 = var.az-storage-container
  storage_account_name = azurerm_storage_account.state-sta.name

}