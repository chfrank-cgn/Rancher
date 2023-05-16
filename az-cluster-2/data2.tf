#  Startup script

# Registration command
data "template_file" "startup-script_data" {
  template = file("${path.module}/files/startup-script")
  vars = {
    registration_command = "${rancher2_cluster_v2.cluster_az.cluster_registration_token.0.node_command} --etcd --controlplane --worker"
  }
  depends_on = [rancher2_cluster_v2.cluster_az]
}

