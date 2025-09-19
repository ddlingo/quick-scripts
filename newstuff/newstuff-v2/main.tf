locals {
  imported_group_role_map = jsondecode(file("${path.module}/group_role_map.json"))
  group_role_pairs = flatten([
    for group, roles in local.imported_group_role_map : [
      for role in roles : {
        group = group
        role  = role
      }
    ]
  ])
}

data "openstack_identity_group_v3" "federated_groups" {
  for_each = { for pair in local.group_role_pairs : "${pair.group}|${pair.role}" => pair }
  name     = each.value.group
}

data "openstack_identity_role_v3" "roles" {
  for_each = { for pair in local.group_role_pairs : "${pair.group}|${pair.role}" => pair }
  name     = each.value.role
}

resource "openstack_identity_role_assignment_v3" "group_role_assignments" {
  for_each   = { for pair in local.group_role_pairs : "${pair.group}|${pair.role}" => pair }
  group_id   = data.openstack_identity_group_v3.federated_groups[each.key].id
  role_id    = data.openstack_identity_role_v3.roles[each.key].id
  project_id = var.project_id
}
