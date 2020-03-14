# Terraform backend configuration

terraform {

  required_version = ">= 0.12"

  required_providers {
    local = "~> 1.4"
    null = "~> 2.1"
    rancher2 = "~> 1.7"
    random = "~> 2.2"
    template = "~> 2.1"
  }
}

