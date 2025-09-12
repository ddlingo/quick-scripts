# Lookup the federated group by name
data "openstack_identity_group_v3" "federated_group" {
  name      = var.federated_group_local_name
  domain_id = var.domain_id
}

# Lookup each role by name
data "openstack_identity_role_v3" "roles" {
  for_each = toset(var.openstack_role_names)
  name     = each.value
}

# Lookup the project by name
data "openstack_identity_project_v3" "project" {
  name      = var.project_name
  domain_id = var.domain_id
}

# Assign each role to the group in the project
resource "openstack_identity_role_assignment_v3" "group_role_assignments" {
  for_each   = data.openstack_identity_role_v3.roles
  group_id   = data.openstack_identity_group_v3.federated_group.id
  project_id = data.openstack_identity_project_v3.project.id
  role_id    = each.value.id
}

