# Input variables

# Cluster Name
variable "rbac-cluster" {
	default = "xxx-xxxxxx"
}

# Cluster-Role File
variable "rbac-cr-file" {
	default = "rbac-cr.csv"
}

# Project-Role File
variable "rbac-pr-file" {
	default = "rbac-pr.csv"
}

variable "rancher-url" { }

variable "rancher-token" { }
