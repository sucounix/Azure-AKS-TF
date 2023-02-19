#####################################################################
#
#
# Azure Kubernetes Service Configuration File
#
#
# /*

# Terraform Resource to Create Azure Resource Group with Input Variables defined in variables.tf
resource "azurerm_resource_group" "aks_rg" {
  name                              = "${lower(var.company)}-${var.environment}-${var.resource_group_name}"
  location                          = var.location
    tags = {
    environment = var.environment
  }
}


resource "azurerm_kubernetes_cluster" "aks_cluster" {
  dns_prefix                        = "${azurerm_resource_group.aks_rg.name}"
  location                          = azurerm_resource_group.aks_rg.location
  name                              = "${azurerm_resource_group.aks_rg.name}-cluster"
  resource_group_name               = azurerm_resource_group.aks_rg.name
  kubernetes_version                = "1.23.12"
  node_resource_group               = "${azurerm_resource_group.aks_rg.name}-nrg"
  azure_policy_enabled              = true
  http_application_routing_enabled  = true

  default_node_pool {
    name                            = "systempool"
    vnet_subnet_id                  = azurerm_subnet.aks_subnet.id
    vm_size                         = "Standard_B2s"
    orchestrator_version            = "1.23.12"
    zones   = [1, 2, 3]
    enable_auto_scaling             = true
    max_count                       = 3
    min_count                       = 1
    os_disk_size_gb                 = 30
    type                            = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type"               = "system"
      "environment"                 = var.environment
      "nodepoolos"                  = "linux"
      "app"                         = "system-apps"
    }
    tags = {
      "nodepool-type"               = "system"
      "environment"                 = var.environment
      "nodepoolos"                  = "linux"
      "app"                         = "system-apps"
    }
  }

# Identity (System Assigned or Service Principal)
  identity { type              = "SystemAssigned" }
  oms_agent {
  log_analytics_workspace_id   = azurerm_log_analytics_workspace.insights.id
}

# RBAC and Azure AD Integration Block
  azure_active_directory_role_based_access_control {
    managed                    = true
    admin_group_object_ids     = [azuread_group.aks_administrators.id]
    azure_rbac_enabled         = true
  }

# Linux Profile
linux_profile {
  admin_username      = "ubuntu"
  ssh_key {
      key_data        = file(var.ssh_public_key)
  }
}

# Network Profile
network_profile {
load_balancer_sku = "Standard"
  network_plugin      = "azure"
}

# AKS Cluster Tags
tags = {
  Environment         = var.environment
}
  depends_on = [
    azurerm_storage_container.core-container,
    azurerm_subnet.aks_subnet
  ]
}

# Create Azure AD Group in Active Directory for AKS Admins
resource "azuread_group" "aks_administrators" {
  # name        = "${azurerm_resource_group.aks_rg.name}-${var.environment}-administrators"
  display_name        = "${azurerm_resource_group.aks_rg.name}-${var.environment}-administrators"
  description         = "Azure AKS Kubernetes administrators for the ${azurerm_resource_group.aks_rg.name}-${var.environment} cluster."
  security_enabled    = true
}

# Create Linux Azure AKS Node Pool
resource "azurerm_kubernetes_cluster_node_pool" "linux101" {
  vnet_subnet_id                  = azurerm_subnet.aks_subnet.id
  zones                 = [1, 2, 3]
  enable_auto_scaling   = true
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  max_count             = 3
  min_count             = 1
  mode                  = "User"
  name                  = "linux101"
  orchestrator_version  = "1.23.12"
  os_disk_size_gb       = 30
  os_type               = "Linux" # Default is Linux, we can change to Windows
  vm_size               = "Standard_D2_v2"
  priority              = "Regular"  # Default is Regular, we can change to Spot with additional settings like eviction_policy, spot_max_price, node_labels and node_taints
  node_labels = {
    "nodepool-type"     = "user"
    "environment"       = var.environment
    "nodepoolos"        = "linux"
    "app"               = "python-apps"
  }
  tags = {
    "nodepool-type"     = "user"
    "environment"       = var.environment
    "nodepoolos"        = "linux"
    "app"               = "python-apps"
  }
    depends_on = [
    azurerm_kubernetes_cluster.aks_cluster
  ]
}

resource "azurerm_role_assignment" "aks" {
  scope                 = azurerm_kubernetes_cluster.aks_cluster.id
  role_definition_name  = "Monitoring Metrics Publisher"
  principal_id          = azurerm_kubernetes_cluster.aks_cluster.identity[0].principal_id
  depends_on = [azurerm_kubernetes_cluster_node_pool.linux101]
}

# # Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "insights" {
  name                  = "${var.environment}-logs-${random_pet.aksrandom.id}"
  location              = azurerm_resource_group.aks_rg.location
  resource_group_name   = azurerm_resource_group.aks_rg.name
  retention_in_days     = 30
    tags = {
    environment = var.environment
  }
}

resource "azurerm_application_insights" "app_insights" {
name                = format("insights-aks")
resource_group_name = azurerm_resource_group.aks_rg.name
location            = var.location
# workspace_id        = azurerm_log_analytics_workspace.app_insights.id
retention_in_days   = var.retention_in_days
application_type    = "web"
    tags = {
    environment = var.environment
  }
}
resource "azurerm_security_center_subscription_pricing" "aks_cs" {
  tier          = "Standard"
  resource_type = "KubernetesService"
  depends_on = [
    azurerm_kubernetes_cluster_node_pool.linux101
  ]

}

