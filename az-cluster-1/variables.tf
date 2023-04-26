# Input variables

# Node image
variable "image" { 
	default = "Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest"
}

# Node disk size in GB
variable "agent-disk" {
	default = 256
}

# Node disk size in GB
variable "control-disk" {
	default = 128
}

# Node type
variable "agent-type" {
	default = "Standard_D8s_v3"
}

# Node type
variable "control-type" {
	default = "Standard_D2s_v3"
}

# Kubernetes version
variable "k8version" {
	default = "v1.25.7+rke2r1"
}

# Number of nodes
variable "numcontrol" {
	default = 3
}

# Number of nodes
variable "numagent" {
	default = 2
}

# Monitoring chart
variable "monchart" {
	default = "102.0.0"
}

# Logging chart
variable "logchart" {
	default = "102.0.0"
}

# Longhorn chart
variable "longchart" {
	default = "102.2.0"
}

# Bitnami URL
variable "bitnami-url" {
        default = "https://charts.bitnami.com/bitnami"
}

# Azure open ports
variable "az-portlist" {
	type = list(string)
        default = ["80/tcp","443/tcp","6443/tcp","9345/tcp","2379/tcp","2380/tcp","8472/udp","4789/udp","9796/tcp","10256/tcp","10250/tcp","10251/tcp","10252/tcp"]
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

# Azure credentials - workaround 835
variable "credentials" {
	default = "azure"
}

# Hack: Time to wait for Kubernetes to deploy
variable "delaysec" {
	default = 720
}

variable "rancher-url" { }

variable "rancher-token" { }

variable "az-client-id" { }

variable "az-client-secret" { }

variable "az-subscription-id" { }

variable "az-tenant-id" { }

