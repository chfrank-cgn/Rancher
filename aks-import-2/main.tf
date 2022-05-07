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
resource "kubernetes_cluster_role_binding" "import_role_binding" {
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

  depends_on = [rancher2_cluster.cluster_az]
}

# Cluster role
resource "kubernetes_cluster_role" "proxy_clusterrole_kubeapiserver" {
  metadata {
    name = "proxy-clusterrole-kubeapiserver"
  }
  rule {
    verbs      = ["get", "list", "watch", "create"]
    api_groups = [""]
    resources  = ["nodes/metrics", "nodes/proxy", "nodes/stats", "nodes/log", "nodes/spec"]
  }

  depends_on = [kubernetes_cluster_role_binding.import_role_binding]
}

# Cluster role binding
resource "kubernetes_cluster_role_binding" "proxy_role_binding_kubernetes_master" {
  metadata {
    name = "proxy-role-binding-kubernetes-master"
  }
  subject {
    kind = "User"
    name = "kube-apiserver"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "proxy-clusterrole-kubeapiserver"
  }

  depends_on = [kubernetes_cluster_role_binding.import_role_binding]
}

# Namespace
resource "kubernetes_namespace" "cattle_system" {
  metadata {
    name = "cattle-system"
  }

  depends_on = [kubernetes_cluster_role_binding.import_role_binding]
}

# Service account
resource "kubernetes_service_account" "cattle" {
  metadata {
    name      = "cattle"
    namespace = "cattle-system"
  }

  depends_on = [kubernetes_namespace.cattle_system]
}

# Cluster role binding
resource "kubernetes_cluster_role_binding" "cattle_admin_binding" {
  metadata {
    name = "cattle-admin-binding"
    labels = {
      "cattle.io/creator" = "norman"
    }
  }
  subject {
    kind      = "ServiceAccount"
    name      = "cattle"
    namespace = "cattle-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cattle-admin"
  }

  depends_on = [kubernetes_service_account.cattle,kubernetes_cluster_role.cattle_admin]
}

# Registration Secret
resource "kubernetes_secret" "cattle_credentials_az" {
  metadata {
    name      = "cattle-credentials-${random_id.instance_id.hex}"
    namespace = "cattle-system"
  }
  data = {
    token = rancher2_cluster.cluster_az.cluster_registration_token.0.token
    url = var.rancher-url
  }
  type = "Opaque"

  depends_on = [kubernetes_namespace.cattle_system]
}

# Cluster role
resource "kubernetes_cluster_role" "cattle_admin" {
  metadata {
    name = "cattle-admin"
    labels = {
      "cattle.io/creator" = "norman"
    }
  }
  rule {
    verbs      = ["*"]
    api_groups = ["*"]
    resources  = ["*"]
  }
  rule {
    verbs             = ["*"]
    non_resource_urls = ["*"]
  }

  depends_on = [kubernetes_cluster_role_binding.import_role_binding]
}

# Deployment
resource "kubernetes_deployment" "cattle_cluster_agent" {
  metadata {
    name      = "cattle-cluster-agent"
    namespace = "cattle-system"
    annotations = {
      "management.cattle.io/scale-available" = "2"
    }
  }
  spec {
    selector {
      match_labels = {
        app = "cattle-cluster-agent"
      }
    }
    template {
      metadata {
        labels = {
          app = "cattle-cluster-agent"
        }
      }
      spec {
        volume {
          name = "cattle-credentials"
          secret {
            secret_name  = "cattle-credentials-${random_id.instance_id.hex}"
            default_mode = "0500"
          }
        }
        container {
          name  = "cluster-register"
          image = "rancher/rancher-agent:${data.rancher2_setting.server_version.value}"
          env {
            name  = "CATTLE_IS_RKE"
            value = "false"
          }
          env {
            name  = "CATTLE_SERVER"
            value = data.rancher2_setting.server_url.value
          }
          env {
            name = "CATTLE_CA_CHECKSUM"
          }
          env {
            name  = "CATTLE_CLUSTER"
            value = "true"
          }
          env {
            name  = "CATTLE_K8S_MANAGED"
            value = "true"
          }
          env {
            name = "CATTLE_CLUSTER_REGISTRY"
          }
          env {
            name  = "CATTLE_SERVER_VERSION"
            value = data.rancher2_setting.server_version.value
          }
          env {
            name  = "CATTLE_INSTALL_UUID"
            value = data.rancher2_setting.install_uuid.value
          }
          env {
            name  = "CATTLE_INGRESS_IP_DOMAIN"
            value = "sslip.io"
          }
          volume_mount {
            name       = "cattle-credentials"
            read_only  = true
            mount_path = "/cattle-credentials"
          }
          image_pull_policy = "IfNotPresent"
        }
        service_account_name = "cattle"
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "beta.kubernetes.io/os"
                  operator = "NotIn"
                  values   = ["windows"]
                }
              }
            }
            preferred_during_scheduling_ignored_during_execution {
              weight = 100
              preference {
                match_expressions {
                  key      = "node-role.kubernetes.io/controlplane"
                  operator = "In"
                  values   = ["true"]
                }
              }
            }
            preferred_during_scheduling_ignored_during_execution {
              weight = 100
              preference {
                match_expressions {
                  key      = "node-role.kubernetes.io/control-plane"
                  operator = "In"
                  values   = ["true"]
                }
              }
            }
            preferred_during_scheduling_ignored_during_execution {
              weight = 100
              preference {
                match_expressions {
                  key      = "node-role.kubernetes.io/master"
                  operator = "In"
                  values   = ["true"]
                }
              }
            }
            preferred_during_scheduling_ignored_during_execution {
              weight = 1
              preference {
                match_expressions {
                  key      = "cattle.io/cluster-agent"
                  operator = "In"
                  values   = ["true"]
                }
              }
            }
          }
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100
              pod_affinity_term {
                label_selector {
                  match_expressions {
                    key      = "app"
                    operator = "In"
                    values   = ["cattle-cluster-agent"]
                  }
                }
                topology_key = "kubernetes.io/hostname"
              }
            }
          }
        }
        toleration {
          key    = "node-role.kubernetes.io/controlplane"
          value  = "true"
          effect = "NoSchedule"
        }
        toleration {
          key      = "node-role.kubernetes.io/control-plane"
          operator = "Exists"
          effect   = "NoSchedule"
        }
        toleration {
          key      = "node-role.kubernetes.io/master"
          operator = "Exists"
          effect   = "NoSchedule"
        }
      }
    }
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge = "1"
      }
    }
  }

  depends_on = [kubernetes_secret.cattle_credentials_az,kubernetes_service_account.cattle]
}

# Service definition
resource "kubernetes_service" "cattle_cluster_agent" {
  metadata {
    name      = "cattle-cluster-agent"
    namespace = "cattle-system"
  }
  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }
    port {
      name        = "https-internal"
      protocol    = "TCP"
      port        = 443
      target_port = "444"
    }
    selector = {
      app = "cattle-cluster-agent"
    }
  }

  depends_on = [kubernetes_namespace.cattle_system]
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

# Kubeconfig file
resource "local_file" "kubeconfig" {
  filename = "${path.module}/.kube/config"
  content = rancher2_cluster.cluster_az.kube_config
  file_permission = "0600"

  depends_on = [null_resource.delay]
}

