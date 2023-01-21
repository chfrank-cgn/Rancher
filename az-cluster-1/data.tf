# Data sources

# System project
data "rancher2_project" "system" {
    cluster_id = rancher2_cluster_v2.cluster_az.cluster_v1_id
    name = "System"
}


