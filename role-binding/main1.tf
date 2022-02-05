# Cluster Role Bindings

# CSV File
locals {
  cluster_roles = csvdecode(file(var.rbac-cr-file))
}

# User id
data "rancher2_user" "rbac_user" {
  for_each = { for inst in local.cluster_roles : inst.id => inst }

  username = each.value.user
}

# Cluster role binding
resource "rancher2_cluster_role_template_binding" "ec2_cl_role" {
  name = "cr-${each.key}"
  for_each = { for inst in local.cluster_roles : inst.id => inst }

  cluster_id = data.rancher2_cluster.rbac_cluster.id
  role_template_id = each.value.role
  user_id = data.rancher2_user.rbac_user[each.key].id
}

