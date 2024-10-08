# Input variables

# Node type
variable "type" {
	default = "Standard_D4s_v3"
}

# Kubernetes version
variable "k8version" {
	default = "v1.28.12+rke2r1"
}

# Number of nodes
variable "numnodes" {
	default = 3
}

# Logging chart
variable "logchart" {
	default = "103.1.1"
}

# Bitnami URL
variable "bitnami-url" {
        default = "https://charts.bitnami.com/bitnami"
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

# Azure Availability Set
variable "az-avset" {
	default = "docker-machine"
}

# Azure Security Group
variable "az-sec-group" {
	default = "default-firewall"
}

# Hack: Time to wait for Kubernetes to deploy
variable "delaysec" {
	default = 840
}

variable "rancher-url" { }

variable "rancher-token" { }

variable "az-client-id" { }

variable "az-client-secret" { }

variable "az-subscription-id" { }

variable "az-tenant-id" { }

