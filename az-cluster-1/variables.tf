# Input variables

# Node image
variable "image" { 
	default = "canonical:UbuntuServer:18.04-LTS:latest"
}

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
	default = "v1.17.13-rancher1-1"
}

# Docker version
variable "dockerurl" {
	default = "https://releases.rancher.com/install-docker/18.06.sh"
}

# Number of nodes
variable "numnodes" {
	default = 3
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
	default = 1020
}

variable "rancher-url" { }

variable "rancher-token" { }

variable "az-client-id" { }

variable "az-client-secret" { }

variable "az-subscription-id" { }

variable "az-tenant-id" { }

