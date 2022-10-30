# Data sources

# System project
data "rancher2_project" "system" {
    cluster_id = rancher2_cluster_v2.cluster_az.cluster_v1_id
    name = "System"
}

#Workaround for 835
data "rancher2_cloud_credential" "credential_az" {
  name = var.credentials
}

