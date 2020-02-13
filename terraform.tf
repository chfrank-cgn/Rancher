# Terraform backend configuration

terraform {
  backend "remote" {
    organization = "xxxxxxxxxxx"

    workspaces {
      name = "compute-prod-us-central"
    }
  }

  required_version = ">= 0.12"

  required_providers {
    google = "~> 3.4"
    local = "~> 1.4"
    null = "~> 2.1"
    rancher2 = "~> 1.7"
    random = "~> 2.2"
    template = "~> 2.1"
  }
}

