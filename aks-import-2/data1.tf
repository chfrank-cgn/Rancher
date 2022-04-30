# Data sources

# Azure Kubernetes cluster
data "azurerm_kubernetes_cluster" "cluster_aks" {
  name                 = var.az-aks-cluster
  resource_group_name  = var.az-resource-group
}

