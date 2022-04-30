# Terraform provider

# Azure RM
provider "azurerm" {
  client_id = var.az-client-id
  client_secret = var.az-client-secret
  subscription_id = var.az-subscription-id
  tenant_id = var.az-tenant-id
  environment = "public"

  features {}
}

# Rancher
provider "rancher2" {
  api_url = var.rancher-url
  token_key = var.rancher-token
  insecure = true
}

# Kubernetes
provider "kubernetes" {
  host = data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.host
  username = data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.username
  password = data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.password
  client_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.client_certificate)
  client_key = base64decode(data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.cluster_ca_certificate)
}

# Kubectl
provider "kubectl" {
  host = data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.host
  username = data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.username
  password = data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.password
  client_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.client_certificate)
  client_key = base64decode(data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.cluster_ca_certificate)
  load_config_file = false
}

