# Data sources

# Azure subnet
data "azurerm_subnet" "subnet_az" {
  name = var.az-subnet
  virtual_network_name = var.az-vnet
  resource_group_name  = var.az-resource-group
}

