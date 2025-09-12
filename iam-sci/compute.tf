resource "openstack_compute_instance_v2" "sms_designate" {
  name        = "${var.project_name}-sms-designate"
  image_name  = var.image_name
  flavor_name = var.flavor_name
  key_pair    = var.keypair_name

  network {
    uuid = openstack_networking_network_v2.sms.id
  }

  metadata = local.environment_values.kv
}
