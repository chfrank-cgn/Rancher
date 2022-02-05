# Terraform backend configuration

terraform {
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "~> 1.22"
    }
  }
}

