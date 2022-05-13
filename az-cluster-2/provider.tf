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

