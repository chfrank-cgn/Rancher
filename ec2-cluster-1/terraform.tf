# Terraform backend configuration

terraform {
  backend "remote" {
    organization = "xxxxxxxxxxx"

    workspaces {
      name = "compute-test-eu-central"
    }
  }

  required_version = ">= 0.12"

  required_providers {
    local = "~> 1.4"
    null = "~> 2.1"
    rancher2 = "~> 1.10"
    random = "~> 2.2"
  }
}

