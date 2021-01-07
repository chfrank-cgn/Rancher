# Output variables

# Private IP addresses
output "Private" {
  value = openstack_compute_instance_v2.vm_lc.*.access_ip_v4
}

