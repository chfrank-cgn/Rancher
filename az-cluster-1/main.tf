# Terraform resources 

# Random ID
resource "random_id" "instance_id" {
 byte_length = 3
}

# Rancher cloud credentials
resource "rancher2_cloud_credential" "credential_az" {
  name = "Azure Credentials"
  azure_credential_config {
    client_id = var.az-client-id
    client_secret = var.az-client-secret
    subscription_id = var.az-subscription-id
  }
}

# Rancher machine pool
resource "rancher2_machine_config_v2" "agent_az" {
  generate_name = "${random_id.instance_id.hex}"
  azure_config {
    disk_size = var.agent-disk
    image = var.image
    location = var.az-region
    managed_disks = true
    open_port = var.az-portlist
    private_address_only = false
    resource_group = var.az-resource-group
    storage_type = var.az-storage-type
    size = var.agent-type
  }
}

# Rancher machine pool
resource "rancher2_machine_config_v2" "control_az" {
  generate_name = "${random_id.instance_id.hex}"
  azure_config {
    disk_size = var.control-disk
    image = var.image
    location = var.az-region
    managed_disks = true
    open_port = var.az-portlist
    private_address_only = false
    resource_group = var.az-resource-group
    storage_type = var.az-storage-type
    size = var.control-type
  }
}

# Rancher cluster
resource "rancher2_cluster_v2" "cluster_az" {
  name = "az-${random_id.instance_id.hex}"
  kubernetes_version = var.k8version
  enable_network_policy = false

  annotations = {
    "field.cattle.io/description" = "Terraform"
  }
  local_auth_endpoint {
    enabled = false
  }
  rke_config {
    machine_pools {
      name = "control"
      cloud_credential_secret_name = rancher2_cloud_credential.credential_az.id
      control_plane_role = true
      etcd_role = true
      worker_role = false
      quantity = var.numcontrol 
      machine_config {
        kind = rancher2_machine_config_v2.control_az.kind
        name = rancher2_machine_config_v2.control_az.name
      }
    }
    machine_pools {
      name = "agent"
      cloud_credential_secret_name = rancher2_cloud_credential.credential_az.id
      control_plane_role = false
      etcd_role = false
      worker_role = true
      quantity = var.numagent 
      machine_config {
        kind = rancher2_machine_config_v2.agent_az.kind
        name = rancher2_machine_config_v2.agent_az.name
      }
    }
    machine_global_config = <<EOF
cni: canal
EOF
    etcd {
      disable_snapshots = true
    }
  }

  depends_on = [rancher2_cloud_credential.credential_az]
}

# Delay hack part 1
resource "null_resource" "before" {
  depends_on = [rancher2_cluster_v2.cluster_az]
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
  content = rancher2_cluster_v2.cluster_az.kube_config
  file_permission = "0600"

  depends_on = [null_resource.delay]
}

# Cluster monitoring
resource "rancher2_app_v2" "monitor_az" {
  lifecycle {
    ignore_changes = all
  }
  cluster_id = rancher2_cluster_v2.cluster_az.cluster_v1_id
  name = "rancher-monitoring"
  namespace = "cattle-monitoring-system"
  project_id = data.rancher2_project.system.id
  repo_name = "rancher-charts"
  chart_name = "rancher-monitoring"
  chart_version = var.monchart
  values = templatefile("${path.module}/files/values.yaml", {})

  depends_on = [local_file.kubeconfig,rancher2_cluster_v2.cluster_az]
}

# Cluster logging
resource "rancher2_app_v2" "syslog_az" {
  lifecycle {
    ignore_changes = all
  }
  cluster_id = rancher2_cluster_v2.cluster_az.cluster_v1_id
  name = "rancher-logging"
  namespace = "cattle-logging-system"
  project_id = data.rancher2_project.system.id
  repo_name = "rancher-charts"
  chart_name = "rancher-logging"
  chart_version = var.logchart

  depends_on = [rancher2_app_v2.monitor_az,rancher2_cluster_v2.cluster_az]
}

# Longhorn
resource "rancher2_app_v2" "longhorn_az" {
  lifecycle {
    ignore_changes = all
  }
  cluster_id = rancher2_cluster_v2.cluster_az.cluster_v1_id
  name = "longhorn"
  namespace = "longhorn-system"
  project_id = data.rancher2_project.system.id
  repo_name = "rancher-charts"
  chart_name = "longhorn"
  chart_version = var.longchart
  values = templatefile("${path.module}/files/values-longhorn.yaml", {})

  depends_on = [rancher2_app_v2.syslog_az,rancher2_cluster_v2.cluster_az]
}


# Bitnami Catalog
resource "rancher2_catalog_v2" "bitnami_az" {
  lifecycle {
    ignore_changes = all
  }
  cluster_id = rancher2_cluster_v2.cluster_az.cluster_v1_id
  name = "bitnami"
  url = var.bitnami-url

  depends_on = [rancher2_app_v2.longhorn_az,rancher2_cluster_v2.cluster_az]
}

