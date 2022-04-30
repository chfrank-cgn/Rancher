# Input variables

# Node image
variable "image" { 
	default = "ubuntu-os-cloud/ubuntu-minimal-1804-lts"
}

# Node disk size in GB
variable "disksize" {
	default =128 
}

# Node type
variable "type" {
	default = "e2-standard-4"
}

# Kubernetes version
variable "k8version" {
	default = "v1.19.16-rancher1-3"
}

# Number of nodes
variable "numnodes" {
	default = 3
}

# Monitoring chart
variable "monchart" {
	default = "100.1.0"
}

# Logging chart
variable "logchart" {
	default = "100.0.1"
}

# Bitnami URL
variable "bitnami-url" {
	default = "https://charts.bitnami.com/bitnami"
}

# Prometheus URL
variable "prom-url" {
	default = "https://prometheus-community.github.io/helm-charts"
}

# Hack: Time to wait for Kubernetes to deploy
variable "delaysec" {
	default = 660
}

variable "rancher-url" { }

variable "rancher-token" { }

variable "prom-remote-user" { }

variable "prom-remote-pass" { }

