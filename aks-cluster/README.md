# AKS Cluster

Even though [Rancher](https://rancher.com/) offers a cluster driver for [Azure AKS](https://azure.microsoft.com/en-us/services/kubernetes-service/), it can sometimes be helpful to create and import an AKS cluster, as it provides complete flexibility when defining the cluster.

Here we'll use [Terraform](https://www.terraform.io/) to create and import an AKS cluster into Rancher. For more details on Rancher's options for cluster registration, look at the Rancher [documentation](https://rancher.com/docs/rancher/v2.6/en/cluster-provisioning/registered-clusters/).

## Terraform Provider

As a first step, we need to define the Terraform [Rancher2 provider](https://registry.terraform.io/providers/rancher/rancher2/latest/docs):

```
provider "rancher2" {
  api_url = var.rancher-url
  token_key = var.rancher-token
}
```

and the Terraform [Azure provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs):

```
provider "azurerm" {
  client_id = var.az-client-id
  client_secret = var.az-client-secret
  subscription_id = var.az-subscription-id
  tenant_id = var.az-tenant-id
  environment = "public"

  features {}
}
```

and finally, the Terraform [Kubernetes provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs):

```
provider "kubernetes" {
  host = data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.host
  username = data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.username
  password = data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.password
  client_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.client_certificate)
  client_key = base64decode(data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.cluster_ca_certificate)
}
```

## Rancher cluster creation

We define our cluster in Rancher:

```
resource "rancher2_cluster" "cluster_az" {
  name         = "aks-${random_id.instance_id.hex}"
  description  = "Terraform"
}
```

We then retrieve a couple of settings from Rancher, which we will later need to complete the installation:

```
data "rancher2_setting" "server_version" {
    name = "server-version"
}
data "rancher2_setting" "install_uuid" {
    name = "install-uuid"
}
data "rancher2_setting" "server_url" {
    name = "server-url"
}
```

and prepare the registration secret for the cattle-cluster-agent:

```
resource "kubernetes_secret" "cattle_credentials_az" {
  metadata {
    name      = "cattle-credentials-${random_id.instance_id.hex}"
    namespace = "cattle-system"
  }
  data = {
    token = rancher2_cluster.cluster_az.cluster_registration_token.0.token
    url = var.rancher-url
  }
  type = "Opaque"
}
```

## AKS cluster creation

Using the Azure provider, we create the AKS cluster itself:

```
resource "azurerm_kubernetes_cluster" "cluster_az" {
  name                = "aks-${random_id.instance_id.hex}"
  location            = var.az-region
  resource_group_name = var.az-resource-group
  dns_prefix          = "aks-${random_id.instance_id.hex}"
  default_node_pool {
    name       = "agent${random_id.instance_id.hex}"
    node_count = var.numnodes
    vm_size    = var.type
  }
  identity {
    type = "SystemAssigned"
  }
}
```

## Import

Now we're ready for the actual import. The Rancher GUI would present us with a Kubernetes manifest to apply; we can use [k2tf](https://github.com/sl1pm4t/k2tf) or a similar tool to convert the manifest to HCL and use it directly in Terraform.

To make the import universal, we substitute some data in the manifest with the variables we retrieved from Rancher earlier. You can find a converted and rather lengthy manifest in `main.tf`.

### Lifecycle protection

The cattle-cluster-agent will modify some of the resources during its startup, so we need to protect all the converted Kubernetes resources in the manifest from Terraform lifecycle changes:

```
  lifecycle {
    ignore_changes = all
  }
```

### Finalizer

Destroying the imported cluster with Terraform will fail due to a finalizer in the cattle-system namespace. As a workaround, remove the finalizer as the last step during cluster creation:

```
kubectl patch namespace cattle-system -p '{"metadata":{"finalizers":[]}}' --type='merge' -n cattle-system
```

Happy Ranching!
