output "assigned_roles" {
  value = {
    for k, v in data.openstack_identity_role_v3.roles : k => v.id
  }
}
