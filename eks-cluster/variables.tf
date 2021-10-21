# Input variables

# Node disk size in GB
variable "disksize" {
	default = 32
}

# Node type
variable "type" {
	default = "t3.large"
}

# Kubernetes version
variable "k8version" {
	default = "1.21"
}

# Number of nodes
variable "numnodes" {
	default = 2
}

# EC2 Region
variable "ec2-region" {
	default = "eu-central-1"
}

variable "rancher-url" { }

variable "rancher-token" { }

variable "ec2-access-key" { }

variable "ec2-secret-key" { }

