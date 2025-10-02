resource "openstack_identity_group_v3" "role_groups" {
  for_each = var.group_role_mapping
  name     = each.key
}

# Create a local value for all group/role pairs
locals {
  group_role_pairs = flatten([
    for group, roles in var.group_role_mapping : [
      for role in roles : {
        group = group
        role  = role
      }
    ]
  ])
}

# Lookup role IDs for each role name
data "openstack_identity_role_v3" "roles" {
  for_each = { for pair in local.group_role_pairs : "${pair.group}/${pair.role}" => pair.role }
  name     = each.value
}

# Create group-role assignments
resource "openstack_identity_role_assignment_v3" "group_assignments" {
  for_each   = { for pair in local.group_role_pairs : "${pair.group}/${pair.role}" => pair }
  group_id   = openstack_identity_group_v3.role_groups[each.value.group].id
  project_id = var.project_id
  role_id    = data.openstack_identity_role_v3.roles["${each.value.group}/${each.value.role}"].id
}
