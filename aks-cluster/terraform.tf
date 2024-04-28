# Terraform backend configuration

terraform {
  backend "remote" {
    organization = "xxxxxxxxxxx"

    workspaces {
      name = "compute-test-eastus"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.101"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.29"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "~> 4.1"
    }
  }
}

