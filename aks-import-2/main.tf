# Terraform resources 

# Random ID
resource "random_id" "instance_id" {
 byte_length = 3
}

# Rancher cluster
resource "rancher2_cluster" "cluster_az" {
  name         = "aks-${random_id.instance_id.hex}"
  description  = "Terraform"

}

# Cluster role binding
resource "kubernetes_cluster_role_binding" "import_az" {
  lifecycle {
    ignore_changes = all
  }
  metadata {
    name = "cluster-admin-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "User"
    name      = data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.username
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "null_resource" "manifest" {
  provisioner "local-exec" {
    command = "curl -L ${rancher2_cluster.cluster_az.cluster_registration_token.0.manifest_url} -o /tmp/aks-${random_id.instance_id.hex}.yaml"
  }

  depends_on = [rancher2_cluster.cluster_az]
}

# Delay hack part 1
resource "null_resource" "before" {
  depends_on = [rancher2_cluster.cluster_az]
}

# Delay hack part 2
resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep ${var.delaysec}"
  }

  triggers = {
    "before" = "null_resource.before.id"
  }
}

resource "kubectl_manifest" "apply_manifest" {
  lifecycle {
    ignore_changes = all
  }
  for_each = data.kubectl_path_documents.import_manifest.manifests
  yaml_body = each.value
  wait_for_rollout = false
}

# Kubeconfig file
resource "local_file" "kubeconfig" {
  filename = "${path.module}/.kube/config"
  content = rancher2_cluster.cluster_az.kube_config
  file_permission = "0600"

  depends_on = [null_resource.delay]
}

