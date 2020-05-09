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

# Rancher node template
resource "rancher2_node_template" "template_az" {
  name = "Azure Node Template"
  cloud_credential_id = rancher2_cloud_credential.credential_az.id
  engine_install_url = var.dockerurl
  azure_config {
    disk_size = var.disksize
    image = var.image
    location = var.az-region
    managed_disks = true
    no_public_ip = false
    open_port = var.az-portlist
    resource_group = var.az-resource-group
    storage_type = var.az-storage-type
    size = var.type
    use_private_ip = false
  }
}

# Rancher cluster template 
resource "rancher2_cluster_template" "template_az" {
  name = "Azure Cluster Template"
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
        cloud_provider {
          name = "azure"
          azure_cloud_provider {
            aad_client_id = var.az-client-id
            aad_client_secret = var.az-client-secret
            subscription_id = var.az-subscription-id
            tenant_id = var.az-tenant-id
            resource_group = var.az-resource-group
          }
        }
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
  }
}

# Rancher cluster
resource "rancher2_cluster" "cluster_az" {
  name         = "az-${random_id.instance_id.hex}"
  description  = "Terraform"
  cluster_template_id = rancher2_cluster_template.template_az.id
  cluster_template_revision_id = rancher2_cluster_template.template_az.default_revision_id
  depends_on = [rancher2_cluster_template.template_az]
}

# Rancher node pool
resource "rancher2_node_pool" "nodepool_az" {
  cluster_id = rancher2_cluster.cluster_az.id
  name = "nodepool"
  hostname_prefix = "rke-${random_id.instance_id.hex}-"
  node_template_id = rancher2_node_template.template_az.id
  quantity = var.numnodes
  control_plane = true
  etcd = true
  worker = true
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
    "before" = "${null_resource.before.id}"
  }
}

# Kubeconfig file
resource "local_file" "kubeconfig" {
  filename = "${path.module}/.kube/config"
  content = rancher2_cluster.cluster_az.kube_config
  file_permission = "0600"

  depends_on = [null_resource.delay]
}

# Cluster logging
resource "rancher2_cluster_logging" "az_syslog" {
  name = "az_syslog"
  cluster_id = rancher2_cluster.cluster_az.id
  kind = "syslog"
  syslog_config {
    endpoint = "rancher.chfrank.net:514"
    protocol = "udp"
    program = "az-${random_id.instance_id.hex}"
    severity = "notice"
    ssl_verify = false
  }

  depends_on = [local_file.kubeconfig]
}

