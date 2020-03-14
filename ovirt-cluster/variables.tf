# Basic

variable "vm_control" {
  description = "Unique names for the control nodes"
  default     = ["node-1","node-2","node-3"]
}
variable "vm_worker" {
  description = "Unique names for the worker nodes"
  default     = ["node-4","node-5","node-6"]
}
variable "cluster_id" {
  description = "The ID of cluster the VMs belong to"
  default     = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
variable "vm_template_id" {
  description = "The ID of template the VMs are based on"
  default     = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
variable "vm_memory" {
  description = "The amount of memory of the VM (in metabytes)"
  default     = "4096"
}
variable "vm_cpu_cores" {
  description = "The amount of cores"
  default     = "2"
}
variable "vm_cpu_sockets" {
  description = "The amount of sockets"
  default     = "1"
}
variable "vm_cpu_threads" {
  description = " The amount of threads"
  default     = "1"
}

# VM initialization

variable "vm_dns_search" {
  description = "The dns search path for the VMs"
  default     = "domain.com"
}
variable "vm_dns_servers" {
  description = "The dns server for the VMs"
  default     = "192.168.0.250 192.168.0.251"
}

# Nic Initialization

variable "vm_nic_device" {
  description = "The vNIC to apply this configuration."
  default     = "ens3"
}
variable "vm_nic_boot_proto" {
  description = "The boot protocol for the vNIC configuration."
  default     = "static"
}
variable "vm_nic_ip_address_control" {
  description = "The IP address for the control nodes"
  default     = ["192.168.0.1","192.168.0.2","192.168.0.3"]
}
variable "vm_nic_ip_address_worker" {
  description = "The IP address for the worker nodes"
  default     = ["192.168.0.4","192.168.0.5","192.168.0.6"]
}
variable "vm_nic_gateway" {
  description = "The gateway for the vNIC"
  default     = "192.168.0.254"
}
variable "vm_nic_netmask" {
  description = "The netmask for the vNIC"
  default     = "255.255.255.0"
}
variable "vm_nic_on_boot" {
  description = "The flag to indicate whether the vNIC will be activated at VM booting"
  default     = "true"
}

# Credentials

variable "ovirt-user" { }

variable "ovirt-pass" { }

variable "ovirt-url" { }

variable "rancher-url" { }

variable "rancher-token" { }

