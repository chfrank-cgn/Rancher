# Values

# Cluster name
data "template_file" "values-yaml_data" {
  template = file("${path.module}/files/values.yaml")
  vars = {
    cluster_name = "${rancher2_cluster.cluster_ec2.name}"
  }
}

