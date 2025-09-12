resource "openstack_networking_network_v2" "sms" {
  name           = "${var.project_name}-sms-net"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "sms" {
  name            = "${var.project_name}-sms-subnet"
  network_id      = openstack_networking_network_v2.sms.id
  cidr            = var.sms_net_cidr
  ip_version      = 4
  dns_nameservers = var.dns_nameservers
}

resource "openstack_networking_network_v2" "bind" {
  name           = "${var.project_name}-bind-net"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "bind" {
  name            = "${var.project_name}-bind-subnet"
  network_id      = openstack_networking_network_v2.bind.id
  cidr            = var.bind_net_cidr
  ip_version      = 4
  dns_nameservers = var.dns_nameservers
}

resource "openstack_networking_router_v2" "sms_router" {
  name                = "${var.project_name}-router"
  external_network_id = data.openstack_networking_network_v2.external.id
}

data "openstack_networking_network_v2" "external" {
  name = var.external_network_name
}

resource "openstack_networking_router_interface_v2" "sms_router_sms" {
  router_id = openstack_networking_router_v2.sms_router.id
  subnet_id = openstack_networking_subnet_v2.sms.id
}

resource "openstack_networking_router_interface_v2" "sms_router_bind" {
  router_id = openstack_networking_router_v2.sms_router.id
  subnet_id = openstack_networking_subnet_v2.bind.id
}
