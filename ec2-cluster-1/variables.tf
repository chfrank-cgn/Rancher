# Input variables

# Node image
variable "image" { 
	default = "ami-02584c1c9d05efa69"
}

# Node disk size in GB
variable "disksize" {
	default = 128
}

# Node type
variable "type" {
	default = "m5a.xlarge"
}

# Kubernetes version
variable "k8version" {
	default = "v1.22.9-rancher1-1"
}

# Docker version
variable "dockerurl" {
	default = "https://releases.rancher.com/install-docker/20.10.sh"
}

# Number of nodes
variable "numnodes" {
	default = 3
}

# Monitoring chart
variable "monchart" {
	default = "100.1.2"
}

# Logging chart
variable "logchart" {
	default = "100.1.1"
}

# Longhorn chart
variable "longchart" {
	default = "100.1.2"
}

# Bitnami URL
variable "bitnami-url" {
        default = "https://charts.bitnami.com/bitnami"
}

# Prometheus URL
variable "prom-url" {
        default = "https://prometheus-community.github.io/helm-charts"
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

