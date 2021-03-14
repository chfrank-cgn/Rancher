# Helm resources 

# NFS storage class
resource "helm_release" "nfs_client" {
  name = "nfs-client"
  repository = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/"
  chart = "nfs-subdir-external-provisioner"
  namespace = "kube-public"

  set { 
    name = "nfs.server"
    value= "xxxxxxxxxxx"
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

}

