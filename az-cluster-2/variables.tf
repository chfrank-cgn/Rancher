# Input variables

# Node type
variable "type" {
	default = "Standard_D4s_v3"
}

# Kubernetes version
variable "k8version" {
	default = "v1.21.8-rancher2-1"
}

# Number of nodes
variable "numnodes" {
	default = 3
}

# Monitoring chart
variable "monchart" {
	default = "100.1.0"
}

# Logging chart
variable "logchart" {
	default = "100.0.1"
}

# Azure Resource Group
variable "az-resource-group" {
	default = "az-cluster-2"
}

# Azure Vnet
variable "az-vnet" {
	default = "default-vnet"
}

# Azure Subnet
variable "az-subnet" {
	default = "default"
}

# Azure Region
variable "az-region" {
	default = "eastus"
}

# Hack: Time to wait for Kubernetes to deploy
variable "delaysec" {
	default = 960
}

variable "rancher-url" { }

variable "rancher-token" { }

variable "az-client-id" { }

variable "az-client-secret" { }

variable "az-subscription-id" { }

variable "az-tenant-id" { }

