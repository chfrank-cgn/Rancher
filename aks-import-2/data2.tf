# Data sources

# Manifest
data "kubectl_path_documents" "import_manifest" {
    pattern = "/tmp/aks-${random_id.instance_id.hex}.yaml"
    depends_on = [null_resource.manifest]
}

