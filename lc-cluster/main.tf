# Terraform resources 

# Random ID
resource "random_id" "instance_id" {
 byte_length = 3
}

# Rancher cluster
resource "rancher2_cluster" "cluster_lc" {
  name         = "lc-${random_id.instance_id.hex}"
  description  = "Terraform"

  rke_config {
    kubernetes_version = var.k8version
    cloud_provider {
      name = "openstack"
      openstack_cloud_provider {
        global {
          auth_url = "https://the.greenedge.cloud:5000"
          username = var.lc-user
          password = var.lc-password
          tenant_name = "chfrank"
          domain_name = "Default"
        }
        block_storage {
          ignore_volume_az = true
          trust_device_path = false
          bs_version = "v2"
        }
        load_balancer {
          lb_version = "v2"
          manage_security_groups = false
          use_octavia = true
          subnet_id = var.subnet_id
          floating_network_id = var.floating_id
          create_monitor = false
        }
        metadata {
          request_timeout = 0
        }
      }
    }
    ignore_docker_version = false
    network {
      plugin = "flannel"
    }
    services { 
      etcd {
        backup_config {
          enabled = false
        }
      }
      kubelet {
        extra_args  = {
          max_pods = 70
        }
      }
    }
  }
}

# Worker nodes and control plane
resource "openstack_compute_instance_v2" "vm_lc" {
  name         = "rke-${random_id.instance_id.hex}-${count.index}"
  flavor_name = var.flavor
  image_name = var.image
  key_pair = var.keypair
  security_groups = ["default"]
  count = var.numnodes
  user_data = data.template_file.startup-script_data.rendered

  network {
    name = var.network
  }

}

# Delay hack part 1
resource "null_resource" "before" {
  depends_on = [rancher2_cluster.cluster_lc]
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
  content = rancher2_cluster.cluster_lc.kube_config
  file_permission = "0600"

  depends_on = [null_resource.delay]
}

# Cluster monitoring
resource "rancher2_app_v2" "monitor_lc" {
  lifecycle {
    ignore_changes = all
  }
  cluster_id = rancher2_cluster.cluster_lc.id
  name = "rancher-monitoring"
  namespace = "cattle-monitoring-system"
  repo_name = "rancher-charts"
  chart_name = "rancher-monitoring"
  chart_version = var.monchart
  values = templatefile("${path.module}/files/values.yaml", {})

  depends_on = [local_file.kubeconfig,rancher2_cluster.cluster_lc,openstack_compute_instance_v2.vm_lc]
}

# Cluster logging CRD
resource "rancher2_app_v2" "syslog_crd_lc" {
  lifecycle {
    ignore_changes = all
  }
  cluster_id = rancher2_cluster.cluster_lc.id
  name = "rancher-logging-crd"
  namespace = "cattle-logging-system"
  repo_name = "rancher-charts"
  chart_name = "rancher-logging-crd"
  chart_version = var.logchart

  depends_on = [rancher2_app_v2.monitor_lc,rancher2_cluster.cluster_lc,openstack_compute_instance_v2.vm_lc]
}

# Cluster logging
resource "rancher2_app_v2" "syslog_lc" {
  lifecycle {
    ignore_changes = all
  }
  cluster_id = rancher2_cluster.cluster_lc.id
  name = "rancher-logging"
  namespace = "cattle-logging-system"
  repo_name = "rancher-charts"
  chart_name = "rancher-logging"
  chart_version = var.logchart

  depends_on = [rancher2_app_v2.syslog_crd_lc,rancher2_cluster.cluster_lc,openstack_compute_instance_v2.vm_lc]
}

