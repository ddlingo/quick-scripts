output "group_role_assignments" {
  value = {
    for k, v in openstack_identity_role_assignment_v3.group_assignments :
    k => {
      group_id = v.group_id
      role_id  = v.role_id
    }
  }
}
