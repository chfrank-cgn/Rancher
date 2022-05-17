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
}

# Kubernetes
provider "kubernetes" {
  host = azurerm_kubernetes_cluster.cluster_az.kube_config.0.host
  username = azurerm_kubernetes_cluster.cluster_az.kube_config.0.username
  password = azurerm_kubernetes_cluster.cluster_az.kube_config.0.password
  client_certificate = base64decode(azurerm_kubernetes_cluster.cluster_az.kube_config.0.client_certificate)
  client_key = base64decode(azurerm_kubernetes_cluster.cluster_az.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.cluster_az.kube_config.0.cluster_ca_certificate)
}

