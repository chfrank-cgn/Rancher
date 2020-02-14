# Terraform backend configuration

terraform {
  backend "remote" {
    organization = "xxxxxxxxxxx"

    workspaces {
      name = "compute-helm-us-central"
    }
  }

  required_version = ">= 0.12"

  required_providers {
    helm = "~> 0.10"
    kubernetes = "~> 1.10"
  }
}
