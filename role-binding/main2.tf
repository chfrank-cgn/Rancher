# Project Role Bindings

# CSV File
locals {
  project_roles = csvdecode(file(var.rbac-pr-file))
}

# User id
data "rancher2_user" "rbac_project_user" {
  for_each = { for inst in local.project_roles : inst.id => inst }

  username = each.value.user
}

# Project id
data "rancher2_project" "rbac_project" {
  for_each = { for inst in local.project_roles : inst.id => inst }

  cluster_id = data.rancher2_cluster.rbac_cluster.id
  name = each.value.project
}

# Project role binding
resource "rancher2_project_role_template_binding" "ec2_pr_role" {
  name = "pr-${each.key}"
  for_each = { for inst in local.project_roles : inst.id => inst }

  project_id = data.rancher2_project.rbac_project[each.key].id
  role_template_id = each.value.role
  user_id = data.rancher2_user.rbac_project_user[each.key].id
}

