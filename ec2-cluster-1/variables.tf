# Input variables

# Node image
variable "image" { 
	default = "ami-024e928dca73bfe66"
}

# Node disk size in GB
variable "disksize" {
	default = 32
}

# Node type
variable "type" {
	default = "m3.large"
}

# Kubernetes version
variable "k8version" {
	default = "v1.15.12-rancher2-3"
}

# Docker version
variable "dockerurl" {
	default = "https://releases.rancher.com/install-docker/18.06.sh"
}

# Number of nodes
variable "numnodes" {
	default = 3
}

# EC2 Region
variable "ec2-region" {
	default = "eu-central-1"
}

# EC2 Availability Zone
variable "ec2-zone" {
	default = "a"
}

# EC2 Subnet
variable "ec2-subnet" {
	default = "subnet-f512b39f"
}

# EC2 VPC
variable "ec2-vpc" {
	default = "vpc-090ff663"
}

# EC2 Security Group
variable "ec2-secgroup" {
	default = "rancher-nodes"
}

variable "rancher-url" { }

variable "rancher-token" { }

variable "ec2-access-key" { }

variable "ec2-secret-key" { }

