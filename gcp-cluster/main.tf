# Terraform resources 

# Random ID
resource "random_id" "instance_id" {
 byte_length = 3
}

# Rancher cluster
resource "rancher2_cluster" "cluster_gcp" {
  name         = "gcp-${random_id.instance_id.hex}"
  description  = "Terraform"

  rke_config {
    kubernetes_version = var.k8version
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
resource "google_compute_instance" "vm_gcp" {
  name         = "rke-${random_id.instance_id.hex}-${count.index}"
  machine_type = var.type
  count = var.numnodes

  boot_disk {
    initialize_params {
      image = var.image
      size = var.disksize
    }
  }

  metadata = {
     ssh-keys = "rancher:${file("~/.ssh/id_rsa.pub")}"
  }

  metadata_startup_script = data.template_file.startup-script_data.rendered

  tags = ["http-server", "https-server"]

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config {
    }
  }
}

# Delay hack part 1
resource "null_resource" "before" {
  depends_on = [rancher2_cluster.cluster_gcp]
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
  content = rancher2_cluster.cluster_gcp.kube_config
  file_permission = "0600"

  depends_on = [null_resource.delay]
}

# Cluster logging
resource "rancher2_cluster_logging" "gcp_syslog" {
  name = "gcp_syslog"
  cluster_id = rancher2_cluster.cluster_gcp.id
  kind = "syslog"
  syslog_config {
    endpoint = "rancher:514"
    protocol = "udp"
    program = "gcp-${random_id.instance_id.hex}"
    severity = "notice"
    ssl_verify = false
  }

  depends_on = [local_file.kubeconfig]
}

