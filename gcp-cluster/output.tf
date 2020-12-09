# Output variables

# Public IP addresses
output "Public" {
  value = google_compute_instance.vm_gcp.*.network_interface.0.access_config.0.nat_ip
}

# Private IP addresses
output "Private" {
  value = google_compute_instance.vm_gcp.*.network_interface.0.network_ip
}

