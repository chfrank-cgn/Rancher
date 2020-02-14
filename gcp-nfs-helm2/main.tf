# Kubernetes resources 

# Tiller service account
resource "kubernetes_service_account" "tiller" {
  metadata {
    name = "tiller"
    namespace = "kube-system"
  }
}

# Tiller role binding
resource "kubernetes_cluster_role_binding" "tiller_clusterrolebinding" {
  metadata {
    name = "tiller-clusterrolebinding"
  }
  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "tiller"
    namespace = "kube-system"
  }

  depends_on = [kubernetes_service_account.tiller]
}
