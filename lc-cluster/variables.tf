# Input variables

# Node image
variable "image" { 
	default = "Ubuntu-18.04"
}

# Node type
variable "flavor" {
	default = "ec1.medium"
}

# Network
variable "network" {
	default = "internal"
}

# Network ID
variable "subnet_id" {
          default = "41fbc0c3-f7ac-4e15-be12-83085ac8da7d"
}

# Floating IP
variable "floating_id" {
          default = "ee54f79e-d33a-4866-8df0-4a4576d70243"
}

# Key pair
variable "keypair" {
	default = "minecraft"
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
	default = 720
}

variable "rancher-url" { }

variable "rancher-token" { }

variable "lc-user" { }

variable "lc-password" { }

