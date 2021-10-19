# Terraform backend configuration

terraform {
  backend "remote" {
    organization = "xxxxxxxxxxx"

    workspaces {
      name = "compute-prod-eu-central"
    }
  }

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "~> 1.21"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

