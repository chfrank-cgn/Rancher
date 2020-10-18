# Terraform backend configuration

terraform {
  backend "remote" {
    organization = "xxxxxxxxxxx"

    workspaces {
      name = "compute-prod-us-central"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.43"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "~> 1.10"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }
  }
}

