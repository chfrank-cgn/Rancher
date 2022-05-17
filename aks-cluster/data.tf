# Data sources

# Rancher settings
data "rancher2_setting" "server_version" {
    name = "server-version"
}
data "rancher2_setting" "install_uuid" {
    name = "install-uuid"
}
data "rancher2_setting" "server_url" {
    name = "server-url"
}

# System project
data "rancher2_project" "system" {
    cluster_id = rancher2_cluster.cluster_az.id
    name = "System"
}

