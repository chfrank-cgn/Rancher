# Terraform provider

# Kubernetes
provider "kubernetes" {
  config_path = "${path.module}/../gcp-cluster/.kube/config"
}

# Helm 3
provider "helm" {
  kubernetes {
    config_path = "${path.module}/../gcp-cluster/.kube/config"
  }
}

