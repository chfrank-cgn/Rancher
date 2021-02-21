# Input variables

## Node Template 

# Node template to clone from
variable "image" { 
	default = "/Datacenter/Folder/Templates/ubuntu-lts-mini"
}

# Node disk size in MB
variable "disksize" {
	default = 65536
}

# Node number of CPUs
variable "cpucount" {
	default = 4
}

# Node memory size in MB
variable "memory" {
	default = 8192
}

## Cluster Template

# Kubernetes version
variable "k8version" {
	default = "v1.19.7-rancher1-1"
}

# Docker version
variable "dockerurl" {
	default = "https://releases.rancher.com/install-docker/19.03.sh"
}

## Node pool

# Number of nodes
variable "numnodes" {
	default = 3
}

## Logging and Monitoring

# Monitoring chart
variable "monchart" {
	default = "9.4.202"
}

# Logging chart
variable "logchart" {
	default = "3.8.201"
}

# Time to wait for Kubernetes to deploy before installing
variable "delaysec" {
	default = 780
}

## VMware

# VMware vCenter
variable "vcenter-server" {
	default = "your.vcenter.host"
}

# VMware Datastore
variable "vcenter-datastore" {
	default = "DATASTORE"
}

# VMware Datacenter
variable "vcenter-datacenter" {
	default = "Datacenter"
}

# VMware Resource Pool
variable "vcenter-pool" {
	default = "/Datacenter/Host/Resources/"
}

# VMware Folder
variable "vcenter-folder" {
	default = "Datacenter/Folder"
}

# VMware Network
variable "vcenter-network" {
	default = "vx-network-name"
}

## Defined elsewhere

variable "rancher-url" { }

variable "rancher-token" { }

variable "vcenter-user" { }

variable "vcenter-pass" { }

