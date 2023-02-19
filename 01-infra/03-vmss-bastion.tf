#####################################################################
#
#
# Bastion Host
#
#
# /*

resource "azurerm_public_ip" "agentbastion_pub_ip" {
  name                = "agentbastion_pub_ip"
  location            = azurerm_resource_group.azure_vmss_agents.location
  resource_group_name = azurerm_resource_group.azure_vmss_agents.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "agentbastion" {
  name                = "agentbastion"
  location            = azurerm_resource_group.azure_vmss_agents.location
  resource_group_name = azurerm_resource_group.azure_vmss_agents.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.agentbastion_pub_ip.id
  }
  }
