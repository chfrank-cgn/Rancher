# Terraform backend configuration

terraform {
  backend "remote" {
    organization = "chfrank-cgn"

    workspaces {
      name = "compute-prod-us-central"
    }
  }

  required_version = ">= 0.12"

  required_providers {
    google = "~> 3.28"
    local = "~> 1.4"
    null = "~> 2.1"
    rancher2 = "~> 1.9"
    random = "~> 2.2"
    template = "~> 2.1"
  }
}

