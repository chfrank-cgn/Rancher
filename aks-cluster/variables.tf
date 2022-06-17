# Input variables

# Node type
variable "type" {
	default = "Standard_D4as_v4"
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

# Logging chart
variable "logchart" {
        default = "100.1.2"
}

# Bitnami URL
variable "bitnami-url" {
        default = "https://charts.bitnami.com/bitnami"
}

# Prometheus URL
# variable "prometheus-url" {
#         default = "https://prometheus-community.github.io/helm-charts"
# }

# Grafana URL
# variable "grafana-url" {
#         default = "https://grafana.github.io/helm-charts"
# }

# Hack: Time to wait for Kubernetes to deploy
variable "delaysec" {
	default = 570
}

variable "rancher-url" { }

variable "rancher-token" { }

variable "az-client-id" { }

variable "az-client-secret" { }

variable "az-subscription-id" { }

variable "az-tenant-id" { }

