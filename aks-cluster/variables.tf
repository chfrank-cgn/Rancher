# Input variables

# Node disk size in GB
variable "disksize" {
	default = 30
}

# Node type
variable "type" {
	default = "Standard_D2s_v3"
}

# Kubernetes version
variable "k8version" {
	default = "1.17.11"
}

# Number of nodes
variable "numnodes" {
	default = 3
}

# Azure Resource Group
variable "az-resource-group" {
	default = "aks-cluster"
}

# Azure Vnet
variable "az-vnet" {
        default = "docker-machine-vnet"
}

# Azure Subnet
variable "az-subnet" {
        default = "docker-machine"
}

# Azure Region
variable "az-region" {
	default = "eastus"
}

# AKS Network plugin
variable "az-plugin" {
	default = "kubenet"
}

# Hack: Time to wait for Kubernetes to deploy
variable "delaysec" {
	default = 60
}

variable "rancher-url" { }

variable "rancher-token" { }

variable "az-client-id" { }

variable "az-client-secret" { }

variable "az-subscription-id" { }

variable "az-tenant-id" { }

