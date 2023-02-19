#####################################################################
#
#
# Azure Virtual Machine Scale Sets Azure DevOps Agents Configuration File
#
#
# /*

# Create a Resource Group for the VMSS_Agents
resource "azurerm_resource_group" "azure_vmss_agents" {
  name                    = "${lower(var.company)}-${var.environment}-vmss-agents"
  location                = var.location
    tags = {
    environment = var.environment
  }
}



resource "azurerm_network_security_group" "allow-ssh" {
    name                = "vmss_agents_VM-allow-ssh"
    location            = var.location
    resource_group_name = azurerm_resource_group.azure_vmss_agents.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = var.ssh-source-address
        destination_address_prefix = "*"
    }
}

# Create Azure Virtual Machine Scale Sets
resource "azurerm_linux_virtual_machine_scale_set" "buildagent-vmss" {
  name                               = "buildagent-vmss"
  resource_group_name                = azurerm_resource_group.azure_vmss_agents.name
  location                           = azurerm_resource_group.azure_vmss_agents.location
  sku                                = "Standard_B1s"
  # instances                          = var.numberOfWorkerNodes
  overprovision                      = false
  single_placement_group             = false

  admin_username = "azureuser"
  upgrade_mode   = "Automatic"
  admin_password                     = var.admin_password
  disable_password_authentication    = false

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_public_key)
  }

  source_image_reference {
    publisher                   = "Canonical"
    offer                       = "UbuntuServer"
    sku                         = "18.04-LTS"
    version                     = "latest"
  }

  os_disk {
    storage_account_type        = "Standard_LRS"
    caching                     = "ReadWrite"

  }

  network_interface {
    name                         = "${azurerm_resource_group.azure_vmss_agents.name}-vmss-nic"
    primary                      = true

    ip_configuration {
      name                       = "${azurerm_resource_group.azure_vmss_agents.name}-ip-config"
      primary                    = true
      subnet_id                  = azurerm_subnet.agents_subnet.id
    }
  }
    tags = {
    environment = var.environment
  }
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_subnet.agents_subnet
  ]
}

# Create Azure Virtual Machine Scale Sets Agent Extension
resource "azurerm_virtual_machine_scale_set_extension" "newvmext" {
  name                              = "newvmext"
  virtual_machine_scale_set_id      = azurerm_linux_virtual_machine_scale_set.buildagent-vmss.id
  publisher                         = "Microsoft.Azure.Extensions"
  type                              = "CustomScript"
  type_handler_version              = "2.0"
  protected_settings                = <<PROT
    {
        "script": "${base64encode(templatefile("data/scripts/script.sh", {
          url                       ="${var.url}"
          pat                       ="${var.pat}"
          pool                      ="${var.pool}"
          pyenv_cmd                 ="${var.pyenv_cmd}"
        }))}"
    }
  PROT
  depends_on = [
    azurerm_linux_virtual_machine_scale_set.buildagent-vmss
  ]
}

