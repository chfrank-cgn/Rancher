# Terraform resources 

# Random ID
resource "random_id" "instance_id" {
 byte_length = 3
}

# Rancher cloud credentials
resource "rancher2_cloud_credential" "credential_ec2" {
  name = "EC2 Credentials"
  amazonec2_credential_config {
    access_key = var.ec2-access-key
    secret_key = var.ec2-secret-key
  }
}

# Rancher node template
resource "rancher2_node_template" "template_ec2" {
  name = "EC2 Node Template"
  cloud_credential_id = rancher2_cloud_credential.credential_ec2.id
  engine_install_url = var.dockerurl
  amazonec2_config {
    ami = var.image
    region = var.ec2-region
    security_group = [var.ec2-secgroup]
    subnet_id = var.ec2-subnet
    vpc_id = var.ec2-vpc
    zone = var.ec2-zone
    root_size = var.disksize
    instance_type = var.type
  }
}

# Rancher cluster
resource "rancher2_cluster" "cluster_ec2" {
  name         = "ec2-${random_id.instance_id.hex}"
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

# Rancher node pool
resource "rancher2_node_pool" "nodepool_ec2" {
  cluster_id = rancher2_cluster.cluster_ec2.id
  name = "nodepool"
  hostname_prefix = "rke-${random_id.instance_id.hex}-"
  node_template_id = rancher2_node_template.template_ec2.id
  quantity = var.numnodes
  control_plane = true
  etcd = true
  worker = true
}

# Cluster Sync
resource "rancher2_cluster_sync" "sync_ec2" {
  cluster_id =  rancher2_cluster.cluster_ec2.id
  node_pool_ids = [rancher2_node_pool.nodepool_ec2.id]
}

# Kubeconfig file
resource "local_file" "kubeconfig" {
  filename = "${path.module}/.kube/config"
  content = rancher2_cluster_sync.sync_ec2.kube_config
  file_permission = "0600"
}

# Cluster logging
resource "rancher2_cluster_logging" "ec2_syslog" {
  name = "ec2_syslog"
  cluster_id = rancher2_cluster_sync.sync_ec2.id
  kind = "syslog"
  syslog_config {
    endpoint = "rancher.chfrank.net:514"
    protocol = "udp"
    program = "ec2-${random_id.instance_id.hex}"
    severity = "notice"
    ssl_verify = false
  }
}

