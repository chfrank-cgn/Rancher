# Terraform provider

# Leaf Cloud
provider "openstack" {
  user_name   = var.lc-user
  tenant_name = "chfrank"
  password    = var.lc-password
  auth_url    = "https://the.greenedge.cloud:5000"
}

# Rancher
provider "rancher2" {
  api_url = var.rancher-url
  token_key = var.rancher-token
  insecure = true
}

