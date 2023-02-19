# Agent
pat = ""
pool = ""
url = ""

#Networking
virtual_network_name = "core-vn-01"
network-rg = "Core-VNet"
virtual_network_address_space = ["172.16.0.0/16"]
agents_subnet_name = "agent-subnet-01"
agents_subnet_prefixes = ["172.16.0.0/24"]
aks_subnet_name = "aks-subnet-01"
aks_subnet_address_prefixes = ["172.16.1.0/24"]
sql_subnet_name = "sql-subnet-01"
sql_subnet_prefixes = ["172.16.2.0/24"]
bastion_subnet_prefixes = ["172.16.3.0/24"]