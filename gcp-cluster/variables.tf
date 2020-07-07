# Input variables

# Node image
variable "image" { 
	default = "ubuntu-os-cloud/ubuntu-minimal-1804-lts"
}

# Node disk size in GB
variable "disksize" {
	default = 30
}

# Node type
variable "type" {
	default = "e2-standard-2"
}

# Kubernetes version
variable "k8version" {
	default = "v1.15.12-rancher2-3"
}

# Number of nodes
variable "numnodes" {
	default = 3
}

# Hack: Time to wait for Kubernetes to deploy
variable "delaysec" {
	default = 540
}

variable "rancher-url" { }

variable "rancher-token" { }

