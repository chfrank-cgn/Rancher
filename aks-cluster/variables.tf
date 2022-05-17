# Input variables

# Node type
variable "type" {
	default = "Standard_D4s_v3"
}

# Number of nodes
variable "numnodes" {
	default = 2
}

# Azure Resource Group
variable "az-resource-group" {
	default = "aks-cluster"
}

# Azure Region
variable "az-region" {
	default = "eastus"
}

# Monitoring chart
variable "monchart" {
        default = "100.1.2"
}

# Logging chart
variable "logchart" {
        default = "100.1.1"
}

# Bitnami URL
variable "bitnami-url" {
        default = "https://charts.bitnami.com/bitnami"
}

# Hack: Time to wait for Kubernetes to deploy
variable "delaysec" {
	default = 660
}

variable "rancher-url" { }

variable "rancher-token" { }

variable "az-client-id" { }

variable "az-client-secret" { }

variable "az-subscription-id" { }

variable "az-tenant-id" { }

