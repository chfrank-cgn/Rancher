# Terraform resources 

# Random ID
resource "random_id" "instance_id" {
 byte_length = 3
}

# Rancher cloud credentials
resource "rancher2_cloud_credential" "credential_co" {
  name = "vsphere-${random_id.instance_id.hex}"
  vsphere_credential_config {
    vcenter = var.vcenter-server
    username = var.vcenter-user
    password = var.vcenter-pass
  }
}

# Rancher node template
resource "rancher2_node_template" "template_co" {
  name = "node-${random_id.instance_id.hex}"
  cloud_credential_id = rancher2_cloud_credential.credential_co.id
  engine_install_url = var.dockerurl
  vsphere_config {
    clone_from = var.image
    cpu_count = var.cpucount
    creation_type = "template"
    datacenter = var.vcenter-datacenter
    datastore = var.vcenter-datastore
    disk_size = var.disksize
    folder = var.vcenter-folder
    memory_size = var.memory
    network = [ var.vcenter-network ]
    pool = var.vcenter-pool
  }

  depends_on = [rancher2_cloud_credential.credential_co]
}

# Rancher cluster template 
resource "rancher2_cluster_template" "template_co" {
  name = "cluster-${random_id.instance_id.hex}"
  template_revisions {
    name = "v1"
    default = true
    cluster_config {
      cluster_auth_endpoint {
        enabled = false
      }
      rke_config {
        kubernetes_version = var.k8version
        ignore_docker_version = false
        network {
          plugin = "flannel"
        }
        cloud_provider {
          vsphere_cloud_provider {
            global {
              insecure_flag = true
            }
            virtual_center {
              datacenters = var.vcenter-datacenter
              name        = var.vcenter-server
              user        = var.vcenter-user
              password    = var.vcenter-pass
            }
            workspace {
              server            = var.vcenter-server
              datacenter        = var.vcenter-datacenter
              folder            = "/"
              default_datastore = var.vcenter-datastore
            }
          }
        }
      }
    }
  }

  depends_on = [rancher2_node_template.template_co]
}

# Rancher cluster
resource "rancher2_cluster" "cluster_co" {
  name         = "vm-${random_id.instance_id.hex}"
  description  = "Terraform"
  cluster_template_id = rancher2_cluster_template.template_co.id
  cluster_template_revision_id = rancher2_cluster_template.template_co.default_revision_id

  depends_on = [rancher2_cluster_template.template_co]
}

# Rancher node pool
resource "rancher2_node_pool" "nodepool_co" {
  cluster_id = rancher2_cluster.cluster_co.id
  name = "combined"
  hostname_prefix = "rke-${random_id.instance_id.hex}-"
  node_template_id = rancher2_node_template.template_co.id
  quantity = var.numnodes
  control_plane = true
  etcd = true
  worker = true

  depends_on = [rancher2_cluster_template.template_co]
}

# Delay hack part 1
resource "null_resource" "before" {
  depends_on = [rancher2_cluster.cluster_co,rancher2_node_pool.nodepool_co]
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
  content = rancher2_cluster.cluster_co.kube_config
  file_permission = "0600"

  depends_on = [null_resource.delay]
}

# Cluster monitoring
resource "rancher2_app_v2" "monitor_co" {
  lifecycle {
    ignore_changes = all
  }
  cluster_id = rancher2_cluster.cluster_co.id
  name = "rancher-monitoring"
  namespace = "cattle-monitoring-system"
  repo_name = "rancher-charts"
  chart_name = "rancher-monitoring"
  chart_version = var.monchart
  values = templatefile("${path.module}/files/values.yaml", {})

  depends_on = [local_file.kubeconfig,rancher2_cluster.cluster_co,rancher2_node_pool.nodepool_co]
}

# Cluster logging CRD
resource "rancher2_app_v2" "syslog_crd_co" {
  lifecycle {
    ignore_changes = all
  }
  cluster_id = rancher2_cluster.cluster_co.id
  name = "rancher-logging-crd"
  namespace = "cattle-logging-system"
  repo_name = "rancher-charts"
  chart_name = "rancher-logging-crd"
  chart_version = var.logchart

  depends_on = [rancher2_app_v2.monitor_co,rancher2_cluster.cluster_co,rancher2_node_pool.nodepool_co]
}

# Cluster logging
resource "rancher2_app_v2" "syslog_co" {
  lifecycle {
    ignore_changes = all
  }
  cluster_id = rancher2_cluster.cluster_co.id
  name = "rancher-logging"
  namespace = "cattle-logging-system"
  repo_name = "rancher-charts"
  chart_name = "rancher-logging"
  chart_version = var.logchart

  depends_on = [rancher2_app_v2.syslog_crd_co,rancher2_cluster.cluster_co,rancher2_node_pool.nodepool_co]
}

