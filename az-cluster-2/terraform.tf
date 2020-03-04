# Terraform backend configuration

terraform {
  backend "remote" {
    organization = "xxxxxxxxxxx"

    workspaces {
      name = "compute-prod-eastus"
    }
  }

  required_version = ">= 0.12"

  required_providers {
    azurerm = "~> 2.0"
    local = "~> 1.4"
    null = "~> 2.1"
    rancher2 = "~> 1.7"
    random = "~> 2.2"
    template = "~> 2.1"
  }
}

