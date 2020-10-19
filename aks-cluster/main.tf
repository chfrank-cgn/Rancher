# Terraform resources 

# Random ID
resource "random_id" "instance_id" {
 byte_length = 3
}

# Rancher cluster
resource "rancher2_cluster" "cluster_az" {
  name         = "aks-${random_id.instance_id.hex}"
  description  = "Terraform"

  aks_config {
    agent_dns_prefix = "agent-${random_id.instance_id.hex}"
    master_dns_prefix = "aks-${random_id.instance_id.hex}"
    client_id = var.az-client-id
    client_secret = var.az-client-secret
    subscription_id = var.az-subscription-id
    tenant_id = var.az-tenant-id
    kubernetes_version = var.k8version
    resource_group = var.az-resource-group
    virtual_network_resource_group = var.az-resource-group
    subnet = var.az-subnet
    virtual_network = var.az-vnet
    admin_username = "rancher"
    ssh_public_key_contents = file("~/.ssh/id_rsa.pub")
    agent_vm_size = var.type
    agent_os_disk_size = var.disksize
    agent_pool_name = "rancher0"
    count = var.numnodes
    enable_monitoring = false
    location = var.az-region
    max_pods = 70
    network_plugin = var.az-plugin
  }
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

# Cluster logging
resource "rancher2_cluster_logging" "az_syslog" {
  name = "az_syslog"
  cluster_id = rancher2_cluster.cluster_az.id
  kind = "syslog"
  syslog_config {
    endpoint = "rancher.chfrank.net:514"
    protocol = "udp"
    program = "aks-${random_id.instance_id.hex}"
    severity = "notice"
    ssl_verify = false
  }

  depends_on = [local_file.kubeconfig]
}

