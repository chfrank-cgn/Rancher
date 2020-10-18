# Kubernetes resources 

# Standard storage class
resource "kubernetes_storage_class" "gce_standard" {
  metadata {
    name = "gce-standard"
  }
  storage_provisioner = "kubernetes.io/gce-pd"
  reclaim_policy      = "Delete"
  parameters = {
    type = "pd-standard"
  }
}

# SSD storage class
resource "kubernetes_storage_class" "gce_ssd" {
  metadata {
    name = "gce-ssd"
  }
  storage_provisioner = "kubernetes.io/gce-pd"
  reclaim_policy      = "Delete"
  parameters = {
    type = "pd-ssd"
  }
}

