###########################################
# outputs.tf
# Outputs for group role assignments
###########################################

output "group_role_assignment_ids" {
  description = "IDs of all group role assignments created"
  value       = [for a in openstack_identity_role_assignment_v3.group_role_assignments : a.id]
}

output "group_to_role_assignment_map" {
  description = "Map of each group name to its assigned role and assignment ID"
  value = {
    for k, a in openstack_identity_role_assignment_v3.group_role_assignments :
      k => {
        role_id       = a.role_id
        group_id      = a.group_id
        assignment_id = a.id
      }
  }
}
