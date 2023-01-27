# Terraform backend configuration

terraform {
  backend "remote" {
    organization = "xxxxxxxxxxx"

    workspaces {
      name = "compute-prod-westeurope"
    }
  }

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "~> 1.25"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}

