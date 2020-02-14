# Terraform provider

# Kubernetes
provider "kubernetes" {
  config_path = "${path.module}/../gcp-cluster/.kube/config"
}

# Helm 2
provider "helm" {
  service_account = "tiller"

  kubernetes {
    config_path = "${path.module}/../gcp-cluster/.kube/config"
  }
}
