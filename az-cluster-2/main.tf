# Terraform resources 

# Random ID
resource "random_id" "instance_id" {
 byte_length = 3
}

# Rancher cluster
resource "rancher2_cluster_v2" "cluster_az" {
  name = "az-${random_id.instance_id.hex}"
  kubernetes_version = var.k8version
  enable_network_policy = false

  annotations = {
    "field.cattle.io/description" = "Terraform"
  }
  local_auth_endpoint {
    enabled = false
  }
  rke_config {
    etcd {
      disable_snapshots = true
    }
    machine_global_config = <<EOF
cni: flannel
EOF
  }
}

# Worker nodes and control plane 

# Azure public IP address
resource "azurerm_public_ip" "vm_az_ip" {
  name = "rke-${random_id.instance_id.hex}-${count.index}-ip"
  count = var.numnodes
  location = var.az-region
  resource_group_name = var.az-resource-group
  allocation_method = "Dynamic"
}

# Azure network interface
resource "azurerm_network_interface" "vm_az_nic" {
  name = "rke-${random_id.instance_id.hex}-${count.index}-nic"
  count = var.numnodes
  location = var.az-region
  resource_group_name = var.az-resource-group

  ip_configuration {
    name = "internal"
    subnet_id = data.azurerm_subnet.subnet_az.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vm_az_ip[count.index].id
  }
}

# Azure compute node
resource "azurerm_linux_virtual_machine" "vm_az" {
  name = "rke-${random_id.instance_id.hex}-${count.index}"
  count = var.numnodes
  resource_group_name = var.az-resource-group
  location = var.az-region
  size = var.type
  admin_username = "rancher"
  availability_set_id = data.azurerm_availability_set.avset_az.id
  network_interface_ids = [
    azurerm_network_interface.vm_az_nic[count.index].id,
  ]

  custom_data = base64encode(data.template_file.startup-script_data.rendered)

  admin_ssh_key {
    username = "rancher"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching = "ReadOnly"
    diff_disk_settings {
      option = "Local"
    }
  }
}

# Delay hack part 1
resource "null_resource" "before" {
  depends_on = [rancher2_cluster_v2.cluster_az]
}

# Delay hack part 2
resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep ${var.delaysec}"
  }

  triggers = {
    "before" = "null_resource.before.id"
  }
}

# Kubeconfig file
resource "local_file" "kubeconfig" {
  filename = "${path.module}/.kube/config"
  content = rancher2_cluster_v2.cluster_az.kube_config
  file_permission = "0600"

  depends_on = [null_resource.delay]
}

# Cluster logging
resource "rancher2_app_v2" "syslog_az" {
  lifecycle {
    ignore_changes = all
  }
  cluster_id = rancher2_cluster_v2.cluster_az.cluster_v1_id
  name = "rancher-logging"
  namespace = "cattle-logging-system"
  project_id = data.rancher2_project.system.id
  repo_name = "rancher-charts"
  chart_name = "rancher-logging"
  chart_version = var.logchart
  values = templatefile("${path.module}/files/values-logging.yaml", {})

  depends_on = [local_file.kubeconfig,rancher2_cluster_v2.cluster_az,azurerm_linux_virtual_machine.vm_az]
}

# Bitnami Catalog
resource "rancher2_catalog_v2" "bitnami_az" {
  lifecycle {
    ignore_changes = all
  }
  cluster_id = rancher2_cluster_v2.cluster_az.cluster_v1_id
  name = "bitnami"
  url = var.bitnami-url

  depends_on = [rancher2_app_v2.syslog_az,rancher2_cluster_v2.cluster_az,azurerm_linux_virtual_machine.vm_az]
}

