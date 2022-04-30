# Input variables

# Azure Resource Group
variable "az-resource-group" {
	default = "aks-cluster"
}

# Azure Region
variable "az-region" {
	default = "eastus"
}

# Azure AKS cluster
variable "az-aks-cluster" {
	default = "cluster-2"
}

# Hack: Time to wait for Kubernetes to deploy
variable "delaysec" {
	default = 120
}

variable "rancher-url" { }

variable "rancher-token" { }

variable "az-client-id" { }

variable "az-client-secret" { }

variable "az-subscription-id" { }

variable "az-tenant-id" { }

