# Create project/tenant
resource "openstack_identity_project_v3" "project" {
  name        = var.project_name
  domain_id   = var.domain_id
  description = "Project for ${var.project_name}"
}

# Lookup for custom or standard role
data "openstack_identity_role_v3" "role" {
  name = var.openstack_role_name
}

# Lookup for federated group (populated via Keycloak/SCI)
data "openstack_identity_group_v3" "federated_group" {
  name      = var.federated_group_local_name
  domain_id = var.domain_id
}

# Assign role to federated group on project
resource "openstack_identity_role_assignment_v3" "federated_group_assignment" {
  group_id   = data.openstack_identity_group_v3.federated_group.id
  project_id = openstack_identity_project_v3.project.id
  role_id    = data.openstack_identity_role_v3.role.id
}

# Optional: Local admin user for initial testing/break-glass
resource "openstack_identity_user_v3" "local_admin" {
  count              = var.bootstrap_admin_name != "" ? 1 : 0
  name               = var.bootstrap_admin_name
  password           = var.bootstrap_admin_password
  domain_id          = var.domain_id
  default_project_id = openstack_identity_project_v3.project.id
  enabled            = true
}

data "openstack_identity_role_v3" "admin" {
  name = "admin"
}

resource "openstack_identity_role_assignment_v3" "bootstrap_admin_assignment" {
  count      = var.bootstrap_admin_name != "" ? 1 : 0
  user_id    = openstack_identity_user_v3.local_admin[0].id
  project_id = openstack_identity_project_v3.project.id
  role_id    = data.openstack_identity_role_v3.admin.id
}

output "federated_group_id" {
  value = data.openstack_identity_group_v3.federated_group.id
}
output "project_id" {
  value = openstack_identity_project_v3.project.id
}
output "bootstrap_admin_username" {
  value = var.bootstrap_admin_name
}
