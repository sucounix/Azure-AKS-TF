#####################################################################
#
#
# Azure Database for PostgreSQL Flexible Server Configuration File
#
#
# /*

# Create a Resource Group for the PostgreSQL
resource "azurerm_private_dns_zone" "sql" {
  name                = "sucosql.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.aks_rg.name
    tags = {
    environment = var.environment
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                  = "sucoVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = azurerm_resource_group.aks_rg.name
    tags = {
    environment = var.environment
  }
}

#Create a Resources for the PostgreSQL
resource "azurerm_postgresql_flexible_server" "sql" {
  name                   = "suco-psqlflexibleserver"
  resource_group_name    = azurerm_resource_group.aks_rg.name
  location               = azurerm_resource_group.aks_rg.location
  version                = "12"
  delegated_subnet_id    = azurerm_subnet.sql.id
  private_dns_zone_id    = azurerm_private_dns_zone.sql.id
  administrator_login    = "psqladmin"
  administrator_password = "H@Sh1CoR3!"
  zone                   = "1"
  storage_mb = 32768

  sku_name   = "GP_Standard_D4s_v3"
  depends_on = [azurerm_private_dns_zone_virtual_network_link.sql,
  azurerm_kubernetes_cluster_node_pool.linux101]
    tags = {
    environment = var.environment  
  }
}

