# Output variables

# Application Routing Zone Name
output "Application-Routing" {
  value = azurerm_kubernetes_cluster.cluster_az.http_application_routing_zone_name
}

