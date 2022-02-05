# Global data sources

# Kubernetes cluster
data "rancher2_cluster" "rbac_cluster" {
  name = var.rbac-cluster
}

