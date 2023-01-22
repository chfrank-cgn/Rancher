# RKE2 Cluster

Even on Microsoft Azure, it can make a lot of sense to create an unmanaged Kubernetes cluster instead of using Azure to keep the Kubernetes control plane under your control and ownership.

Since 2.6.X, [Rancher](https://rancher.com/) offers provisioning for RKE2 on all major hyperscalers and virtualization platforms. Here we'll be using Rancher and [Terraform](https://www.terraform.io/) to create a RKE2 cluster and set up two machine pools, one for the control plane and one for the worker nodes.

## Terraform Provider

I'm assuming that you have set up Terraform already. As a first step, we need to define the [Rancher2 provider](https://www.terraform.io/docs/providers/rancher2/index.html):

```
provider "rancher2" {
  api_url = var.rancher-url
  token_key = var.rancher-token
}
```

## Terraform Main

Let's continue with the plan definitions for the actual cluster resources - the cluster itself, its name, and its node pools.

### Random ID

I use Random to have a unique naming identifier for the cluster and its nodes:

```
resource "random_id" "instance_id" {
 byte_length = 3
}
```

### Credentials

The next step is to define the credentials so that Rancher can create all the Azure instances:

```
resource "rancher2_cloud_credential" "credential_az" {
  name = "Azure Credentials"
  azure_credential_config {
    client_id = var.az-client-id
    client_secret = var.az-client-secret
    subscription_id = var.az-subscription-id
  }
}
```

### Machine pools

With the credentials from above, we set up a machine pool for the control plane:

```
resource "rancher2_machine_config_v2" "control_az" {
  generate_name = "${random_id.instance_id.hex}"
  azure_config {
    disk_size = var.control-disk
    image = var.image
    location = var.az-region
    managed_disks = true
    open_port = var.az-portlist
    private_address_only = false
    resource_group = var.az-resource-group
    storage_type = var.az-storage-type
    size = var.control-type
  }
}
```

The machine pool for the worker nodes looks very much the same, just with different node types and sizes

### Variables

I define most values, such as the Kubernetes version to use, the image name, or the number of nodes, as variables to make overall plan maintenance easier:

```
variable "k8version" {
	default = "v1.24.8+rke2r1"
}
variable "image" { 
	default = "Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest"
}
variable "numcontrol" {
    default = 3
}
...
```

### Cluster

Now that we have all set up, it's time to define the Kubernetes cluster, using the name from above and set Kubernetes networking and version:

```
resource "rancher2_cluster_v2" "cluster_az" {
  name = "az-${random_id.instance_id.hex}"
  kubernetes_version = var.k8version
  enable_network_policy = false

  local_auth_endpoint {
    enabled = false
  }
  rke_config {
    machine_pools {
      name = "control"
      cloud_credential_secret_name = rancher2_cloud_credential.credential_az.id
      control_plane_role = true
      etcd_role = true
      worker_role = false
      quantity = var.numcontrol 
      machine_config {
        kind = rancher2_machine_config_v2.control_az.kind
        name = rancher2_machine_config_v2.control_az.name
      }
    }
    machine_pools {
      name = "agent"
      ... 
    }
    machine_global_config = <<EOF
cni: canal
EOF
  }
}
```

### Cluster sync

We're almost ready; just let's wait for the cluster to become active, using a timer:

```
resource "null_resource" "before" {
  depends_on = [rancher2_cluster_v2.cluster_az]
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep ${var.delaysec}"
  }
  triggers = {
    "before" = "null_resource.before.id"
  }
}
```

### Syslog

As the final step, we enable Rancher's logging app from the marketplace:

```
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

  depends_on = [rancher2_cluster_v2.cluster_az]
}
```

For the new v2 app resources, it can be beneficial to add a dependency to the control plane to ensure that the cluster is still accessible while the app resources are being destroyed.

Never run a Kubernetes cluster without monitoring or logging!

### Storage

As a storage provider, we enable Longhorn from the marketplace:

```
resource "rancher2_app_v2" "longhorn_az" {
  lifecycle {
    ignore_changes = all
  }
  cluster_id = rancher2_cluster_v2.cluster_az.cluster_v1_id
  name = "longhorn"
  namespace = "longhorn-system"
  project_id = data.rancher2_project.system.id
  repo_name = "rancher-charts"
  chart_name = "longhorn"
  chart_version = var.longchart
  values = templatefile("${path.module}/files/values-longhorn.yaml", {})

  depends_on = [rancher2_cluster_v2.cluster_az]
}
```

### Ingress

RKE2's built-in ingress controller will listen on the HTTP and HTTPS ports of the worker nodes and will be ready to accept traffic for any deployed applications.

## Troubleshooting

The best place for troubleshooting during plan execution is the output of the pod running Rancher - it provides detailed information on what Rancher is currently doing and complete error messages if something goes wrong.

Happy Ranching!
