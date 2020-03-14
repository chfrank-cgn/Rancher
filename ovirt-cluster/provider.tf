# Terraform provider

# oVirt
provider "ovirt" {
  username = var.ovirt-user
  url      = var.ovrit-url
  password = var.ovirt-pass
}

# Rancher
provider "rancher2" {
  api_url = var.rancher-url
  token_key = var.rancher-token
}

