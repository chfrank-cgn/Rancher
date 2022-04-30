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

# Rancher cluster
resource "rancher2_cluster" "cluster_az" {
  name         = "aks-${random_id.instance_id.hex}"
  description  = "Terraform"

  aks_config_v2 {
    cloud_credential_id = rancher2_cloud_credential.credential_az.id
    name = var.az-aks-cluster
    resource_group = var.az-resource-group
    resource_location = var.az-region
    imported = true
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

