# Data sources

# System project

data "rancher2_project" "system" {
    cluster_id = rancher2_cluster.cluster_ec2.id
    name = "System"
}

