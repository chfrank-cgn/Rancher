# Input variables

# Node image
variable "image" { 
	default = "ami-024e928dca73bfe66"
}

# Node disk size in GB
variable "disksize" {
	default = 64
}

# Node type
variable "type" {
	default = "m3.xlarge"
}

# Kubernetes version
variable "k8version" {
	default = "v1.21.9-rancher1-1"
}

# Docker version
variable "dockerurl" {
	default = "https://releases.rancher.com/install-docker/19.03.sh"
}

# Number of nodes
variable "numnodes" {
	default = 3
}

# Monitoring chart
variable "monchart" {
	default = "100.0.0"
}

# Logging chart
variable "logchart" {
	default = "100.0.0"
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

# Hack: Time to wait for Kubernetes to deploy
variable "delaysec" {
	default = 960
}

variable "rancher-url" { }

variable "rancher-token" { }

variable "ec2-access-key" { }

variable "ec2-secret-key" { }

variable "prom-remote-user" { }

variable "prom-remote-pass" { }

