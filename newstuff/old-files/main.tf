locals {
  roles       = ["Admin", "Eng", "Audit"]
  name_prefix = "SCS_SCI_${var.boundry}_${var.product}${var.function != "" ? "_${var.function}" : ""}_"
}

resource "openstack_identity_group_v3" "role_groups" {
  for_each = toset(local.roles)
  name     = "${local.name_prefix}${each.key}"
}

resource "openstack_identity_role_v3" "roles" {
  for_each = toset(local.roles)
  name     = each.key
}

resource "openstack_identity_role_assignment_v3" "group_assignments" {
  for_each   = toset(local.roles)
  group_id   = openstack_identity_group_v3.role_groups[each.key].id
  project_id = var.project_id
  role_id    = openstack_identity_role_v3.roles[each.key].id
}