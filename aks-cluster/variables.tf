# Input variables

# Node type
variable "type" {
	default = "Standard_D8as_v4"
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

# Kubernetes version
variable "k8version" {
	default = "1.35"
}

# Logging chart
variable "logchart" {
        default = "109.0.0"
}

# OPA chart
variable "opachart" {
        default = "104.0.1"
}

# CIS Benchmarks chart
variable "cischart" {
        default = "109.1.0"
}

# Bitnami URL
variable "bitnami-url" {
        default = "https://charts.bitnami.com/bitnami"
}

# Gatekeeper URL
variable "gatekeeper-url" {
        default = "https://open-policy-agent.github.io/gatekeeper/charts"
}

# Application Collection URL
variable "appco-url" {
        default = "oci://dp.apps.rancher.io/charts"
}

# Hack: Time to wait for Kubernetes to deploy
variable "delaysec" {
	default = 630
}

variable "rancher-url" { }

variable "rancher-token" { }

variable "az-client-id" { }

variable "az-client-secret" { }

variable "az-subscription-id" { }

variable "az-tenant-id" { }

variable "appco-user" { }

variable "appco-token" { }

