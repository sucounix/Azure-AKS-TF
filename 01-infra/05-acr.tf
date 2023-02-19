#####################################################################
#
#
# Azure Container Service Configuration File
#
#
# /*

# Create a Resource Group for the ACR
resource "azurerm_container_registry" "suco_azr" {
  name                             = "sucoazr"
  resource_group_name              = azurerm_resource_group.aks_rg.name
  location                         = azurerm_resource_group.aks_rg.location
  sku                              = "Basic"
    tags = {
    environment = var.environment
  }
    depends_on = [
    azurerm_kubernetes_cluster.aks_cluster
  ]
}

# # Create a Role Assignment to AKS
resource "azurerm_role_assignment" "aks_to_acr_role" {
  scope                = azurerm_container_registry.suco_azr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}