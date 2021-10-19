# Terraform resources 

# Random ID
resource "random_id" "instance_id" {
 byte_length = 3
}

# Rancher cluster
resource "rancher2_cluster" "cluster_eks" {
  name         = "eks-${random_id.instance_id.hex}"
  description  = "Terraform"

  eks_config {
    access_key = var.ec2-access-key
    secret_key = var.ec2-secret-key
    kubernetes_version = var.k8version
    desired_nodes = var.numnodes
    instance_type = var.type
    node_volume_size = var.disksize
    region = var.ec2-region
  }
}

# Kubeconfig file
resource "local_file" "kubeconfig" {
  filename = "${path.module}/.kube/config"
  content = rancher2_cluster.cluster_eks.kube_config
  file_permission = "0600"

}

