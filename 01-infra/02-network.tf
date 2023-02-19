#####################################################################
#
#
# Networking (VNet) Configuration File
#
#
# /*

# Create a Resource Group for the Networking
resource "azurerm_resource_group" "vnet_resource_group" {
  name                        = "${lower(var.company)}-${var.environment}-${var.network-rg}"
  location                    = var.location
  tags = {
    Environment               = var.environment
  }
}

# Create Core Networking Vnet
resource "azurerm_virtual_network" "vnet" {
  name                        = var.virtual_network_name
  resource_group_name         = azurerm_resource_group.vnet_resource_group.name
  location                    = var.location
  address_space               = var.virtual_network_address_space
  tags = {
    Environment = var.environment
  }
}

# Create AKS Subnet
resource "azurerm_subnet" "aks_subnet" {
  name                       = var.aks_subnet_name
  resource_group_name        = azurerm_resource_group.vnet_resource_group.name
  virtual_network_name       = azurerm_virtual_network.vnet.name
  address_prefixes           = var.aks_subnet_address_prefixes
}

# Create VMMS-Agents Subnet
resource "azurerm_subnet" "agents_subnet" {
  name                       = var.agents_subnet_name
  resource_group_name        = azurerm_resource_group.vnet_resource_group.name
  virtual_network_name       = azurerm_virtual_network.vnet.name
  address_prefixes           = var.agents_subnet_prefixes
}
resource "azurerm_subnet" "bastion_subnet" {
  name                       = "AzureBastionSubnet"
  resource_group_name        = azurerm_resource_group.vnet_resource_group.name
  virtual_network_name       = azurerm_virtual_network.vnet.name
  address_prefixes           = var.bastion_subnet_prefixes
}
# Create PostgreSQL Subnet
resource "azurerm_subnet" "sql" {
  name                       = var.sql_subnet_name
  resource_group_name        = azurerm_resource_group.vnet_resource_group.name
  virtual_network_name       = azurerm_virtual_network.vnet.name
  address_prefixes           = var.sql_subnet_prefixes
  service_endpoints          = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
  depends_on = [
    azurerm_storage_container.core-container
  ]

}
## TODO
# resource azurerm_virtual_network_peering peer_to_network {
#   name                         = "${azurerm_virtual_network.network.name}-from-peer"
#   resource_group_name          = data.azurerm_virtual_network.peered_network.0.resource_group_name
#   virtual_network_name         = data.azurerm_virtual_network.peered_network.0.name
#   remote_virtual_network_id    = azurerm_virtual_network.network.id

#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = var.peer_network_has_gateway
#   allow_virtual_network_access = true
#   use_remote_gateways          = false

#   count                        = var.peer_network_id == "" ? 0 : 1
# }