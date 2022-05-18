# Input variables

# Node image
variable "image" { 
	default = "canonical:UbuntuServer:18.04-LTS:latest"
}

# Node disk size in GB
variable "disksize" {
	default = 64
}

# Node type
variable "type" {
	default = "Standard_D4s_v3"
}

# Kubernetes version
variable "k8version" {
	default = "v1.23.6+rke2r2"
}

# Number of nodes
variable "numnodes" {
	default = 3
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

# Azure open ports
variable "az-portlist" {
	type = list(string)
        default = ["80/tcp","443/tcp","6443/tcp","2379/tcp","2380/tcp","8472/udp","4789/udp","9796/tcp","10256/tcp","10250/tcp","10251/tcp","10252/tcp"]
}

# Azure Resource Group
variable "az-resource-group" {
	default = "az-cluster-1"
}

# Azure Region
variable "az-region" {
	default = "eastus"
}

# Azure Storage Type
variable "az-storage-type" {
	default = "Premium_LRS"
}

# Hack: Time to wait for Kubernetes to deploy
variable "delaysec" {
	default = 1140
}

variable "rancher-url" { }

variable "rancher-token" { }

variable "az-client-id" { }

variable "az-client-secret" { }

variable "az-subscription-id" { }

variable "az-tenant-id" { }

