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
      version = "~> 3.13"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.12"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "~> 1.24"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }
  }
}

