# Input variables

# Node image
variable "image" { 
	default = "ubuntu-os-cloud/ubuntu-minimal-1804-lts"
}

# Node disk size in GB
variable "disksize" {
	default = 64
}

# Node type
variable "type" {
	default = "e2-standard-4"
}

# Kubernetes version
variable "k8version" {
	default = "v1.19.12-rancher1-1"
}

# Number of nodes
variable "numnodes" {
	default = 3
}

# Monitoring chart
variable "monchart" {
	default = "14.5.100"
}

# Logging chart
variable "logchart" {
	default = "3.9.400"
}

# Hack: Time to wait for Kubernetes to deploy
variable "delaysec" {
	default = 660
}

variable "rancher-url" { }

variable "rancher-token" { }

