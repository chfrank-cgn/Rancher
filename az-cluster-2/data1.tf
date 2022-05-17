# Data sources

# Azure subnet
data "azurerm_subnet" "subnet_az" {
  name = var.az-subnet
  virtual_network_name = var.az-vnet
  resource_group_name  = var.az-resource-group
}

# Azure availability set
data "azurerm_availability_set" "avset_az" {
  name = var.az-avset
  resource_group_name  = var.az-resource-group
}

# System project
data "rancher2_project" "system" {
    cluster_id = rancher2_cluster.cluster_az.id
    name = "System"
}

