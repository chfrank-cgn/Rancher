# Helm resources 

# NFS storage class
resource "helm_release" "nfs_client" {
  name = "nfs-client"
  chart = "stable/nfs-client-provisioner"
  namespace = "kube-public"

  set { 
    name = "nfs.server"
    value= "xxxxxxxx"
  }
  set { 
    name = "nfs.path"
    value= "/mnt/some/path"
  }
  set { 
    name = "nfs.mountOptions"
    value= "{nfsvers=3}"
  }
  set { 
    name = "storageClass.allowVolumeExpansion"
    value= "false"
  }
  set { 
    name = "storageClass.archiveOnDelete"
    value= "false"
  }
  set { 
    name = "storageClass.defaultClass"
    value= "true"
  }
  set { 
    name = "storageClass.reclaimPolicy"
    value= "Delete"
  }

  depends_on = [kubernetes_cluster_role_binding.tiller_clusterrolebinding]
}
