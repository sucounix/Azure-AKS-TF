


# Backend Configration Outputs
output "terraform_state_resource_group_name" {
  value = azurerm_resource_group.state-rg.name
}
output "terraform_state_storage_account" {
  value = azurerm_storage_account.state-sta.name
}
output "terraform_state_storage_container_core" {
  value = azurerm_storage_container.core-container.name
}

# Azure AKS Outputs
output "location" {
  value = azurerm_resource_group.aks_rg.location
}

output "resource_group_id" {
  value = azurerm_resource_group.aks_rg.id
}

output "resource_group_name" {
  value = azurerm_resource_group.aks_rg.name
}


output "name" {
  value       = azurerm_postgresql_flexible_server.sql.name
  description = "The name of the PostgreSQL Flexible Server"
}

output "id" {
  value       = azurerm_postgresql_flexible_server.sql.id
  description = "The ID of the PostgreSQL Flexible Server"
}

output "fqdn" {
  value       = azurerm_postgresql_flexible_server.sql.fqdn
  description = "The FQDN of the PostgreSQL Flexible Server"
}

output "public_network_access_enabled" {
  value       = azurerm_postgresql_flexible_server.sql.public_network_access_enabled
  description = "Is public network access enabled?"
}

output "administrator_login" {
  value       = azurerm_postgresql_flexible_server.sql.administrator_login
  description = "The administrator login name for the PostgreSQL Flexible Server"
}

output "administrator_password" {
  value       = azurerm_postgresql_flexible_server.sql.administrator_password
  description = "The administrator password for the PostgreSQL Flexible Server"
  sensitive   = true
}
output "aks_subnet_id" {
    description = "id of the subnet"
    value = azurerm_subnet.aks_subnet.id
}


# Azure AD Group Object Id
output "azure_ad_group_id" {
  value = azuread_group.aks_administrators.id
}
output "azure_ad_group_objectid" {
  value = azuread_group.aks_administrators.object_id
}

# Azure ACR Outputs
output "acs-url" {
  value = azurerm_container_registry.suco_azr.login_server
}

# Azure PostgreSQL Outputs
output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.aks_cluster.id
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

output "aks_cluster_kubernetes_version" {
  value = azurerm_kubernetes_cluster.aks_cluster.kubernetes_version
}


output "aks_cluster_kubernetes_private_DNS" {
  value = azurerm_kubernetes_cluster.aks_cluster.dns_prefix_private_cluster
}

