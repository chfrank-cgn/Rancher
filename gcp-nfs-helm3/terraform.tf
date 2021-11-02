# Terraform backend configuration

terraform {
  backend "remote" {
    organization = "xxxxxxxxxxx"

    workspaces {
      name = "compute-helm-us-central"
    }
  }

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.6"
    }
  }
}

