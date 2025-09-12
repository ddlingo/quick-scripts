output "project_id" {
  value = openstack_identity_project_v3.project.id
}

output "sms_network_id" {
  value = openstack_networking_network_v2.sms.id
}
output "bind_network_id" {
  value = openstack_networking_network_v2.bind.id
}
output "sms_subnet_id" {
  value = openstack_networking_subnet_v2.sms.id
}
output "bind_subnet_id" {
  value = openstack_networking_subnet_v2.bind.id
}
output "sms_router_id" {
  value = openstack_networking_router_v2.sms_router.id
}
output "sms_designate_instance_id" {
  value = openstack_compute_instance_v2.sms_designate.id
}

output "federated_group_id" {
  value = data.openstack_identity_group_v3.federated_group.id
}

output "bootstrap_admin_username" {
  value = var.bootstrap_admin_name
}
