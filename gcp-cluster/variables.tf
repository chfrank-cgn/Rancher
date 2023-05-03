# Input variables

# Node image
variable "image" { 
	default = "ubuntu-os-cloud/ubuntu-minimal-2004-lts"
}

# Node disk size in GB
variable "disksize" {
	default = 128 
}

# Node disk type 
variable "disktype" {
	default = "pd-balanced"
}

# Node type
variable "type" {
	default = "n2-standard-4"
}

# Kubernetes version
variable "k8version" {
	default = "v1.25.9-rancher2-1"
}

# Number of nodes
variable "numnodes" {
	default = 3
}

# Monitoring chart
variable "monchart" {
	default = "102.0.0"
}

# Logging chart
variable "logchart" {
	default = "102.0.0"
}

# Longhorn
variable "longchart" {
	default = "102.2.0"
}

# Bitnami URL
variable "bitnami-url" {
	default = "https://charts.bitnami.com/bitnami"
}

# Hack: Time to wait for Kubernetes to deploy
variable "delaysec" {
	default = 780
}

variable "rancher-url" { }

variable "rancher-token" { }

