# Output variables

# Public IP addresses
output "kubectl" {
  value = rancher2_cluster.cluster_az.cluster_registration_token.0.command
}

