# company
variable "company" {
  type = string
  description = "This variable defines the name of the company"
  # default = "suco"
}
# environment
variable "environment" {
  type = string
  description = "This variable defines the environment to be built"
  # default = "Dev"
}
# azure region
variable "location" {
  type = string
  description = "Azure region where resources will be created"
  # default = "East US"
}

# BackEnd-Storage
variable "az-storage-account" {
  type = string
  description = "Azure region where resources will be created"
  # default = "sucotfstorage"
}


# Networking
variable "az-storage-container" {
  type = string
  description = "Azure region where resources will be created"
  # default = "core-tfstate"
}

variable "virtual_network_name" {
    type = string
    description = "name of the virtual network"
}
variable "network-rg" {
    type = string
    description = "resource group name of the virtual network"
}
variable "virtual_network_address_space" {
    type = list(string)
    description = "address space of the virtual network"
}
variable "aks_subnet_name" {
    type = string
    description = "name of the subnet"
}
variable "aks_subnet_address_prefixes" {
    type = list(string)
    description = "address prefix of the subnet"
}

variable "agents_subnet_name" {
    type = string
    description = "name of the subnet"
}
variable "agents_subnet_prefixes" {
    type = list(string)
    description = "address prefix of the subnet"
}


variable "bastion_subnet_prefixes" {
    type = list(string)
    description = "address prefix of the subnet"
}
variable "sql_subnet_name" {
    type = string
    description = "name of the subnet"
}
variable "sql_subnet_prefixes" {
    type = list(string)
    description = "address prefix of the subnet"
}
# Agent-VMSS
variable "numberOfWorkerNodes" {
  type = number
  default = 1
}

variable "ssh-source-address" {
  type    = string
  default = "*"
}

variable scfile{
    type = string
    default = "/home/ec2-user/environment/vmss_with_ext/script.sh"
}

variable "computer_name" {
  default = "hostname"
}

variable "admin_password" {
  default = ""
}


variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

# Agent_Config
variable "url" {
  type = string
  description = "Specify the Azure DevOps url"
}

variable "pat" {
  type = string
  description = "Provide a Personal Access Token (PAT) for Azure DevOps"
}

variable "pool" {
  type = string
  default = "Default"
  description = "Name of the agent pool - must exist before"
}


variable "pyenv_cmd" {
  type = string
  default = "sudo /usr/local/bin/pyenv install 3.7.9"
}

# AKS Input Variables
# AKS Resource Group Name
variable "resource_group_name" {
  type = string
  description = "This variable defines the Resource Group"
  default = "terraform-aks"
}

# SSH Public Key for Linux VMs
variable "ssh_public_key" {
  default = "data/ssh/mykey.pub"
  description = "This variable defines the SSH Public Key for Linux k8s Worker nodes"
}


#Azure Keyvualt
variable "sku_name" {
  description = "The SKU name to use for the Key Vault"
  default = "standard"
}

variable "secret_permissions" {
  type        = list(string)
  description = "The secret permissions to use for the Key Vault"
  default = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
}

variable "key_permissions" {
  type        = list(string)
  description = "The key permissions to use for the Key Vault"
  default = ["Get"]

}

variable "storage_permissions" {
  type        = list(string)
  description = "The storage permissions to use for the Key Vault"
  default = ["Get", "List"]

}

variable "retention_in_days" {
  type        = number
  description = "The retention in days for the application insights"
  default = "30"

}

