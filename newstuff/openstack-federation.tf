########################################################
# openstack-federation.tf — OpenStack Federation Mapping
########################################################

# Maps Keycloak/IdP groups to OpenStack roles for a project.
# All groups and roles must already exist in Keystone.

data "openstack_identity_group_v3" "federated_groups" {
  for_each = local.enable_federation_roles ? var.federated_group_to_role : {}
  name     = each.key
}

data "openstack_identity_role_v3" "roles" {
  for_each = local.enable_federation_roles ? var.federated_group_to_role : {}
  name     = each.value
}

resource "openstack_identity_role_assignment_v3" "group_role_assignments" {
  for_each   = local.enable_federation_roles ? var.federated_group_to_role : {}
  group_id   = data.openstack_identity_group_v3.federated_groups[each.key].id
  role_id    = data.openstack_identity_role_v3.roles[each.key].id
  project_id = var.project_id
}
