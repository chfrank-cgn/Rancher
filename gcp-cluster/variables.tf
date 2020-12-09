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
	default = "v1.18.12-rancher1-1"
}

# Number of nodes
variable "numnodes" {
	default = 3
}

# Monitoring chart
variable "monchart" {
	default = "9.4.201"
}

# Logging chart
variable "logchart" {
	default = "3.6.001"
}

# Hack: Time to wait for Kubernetes to deploy
variable "delaysec" {
	default = 660
}

variable "rancher-url" { }

variable "rancher-token" { }

