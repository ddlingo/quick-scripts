resource "openstack_networking_network_v2" "network" {
  name           = var.network_name
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "subnet" {
  name            = var.subnet_name
  network_id      = openstack_networking_network_v2.network.id
  cidr            = var.cidr
  gateway_ip      = var.gateway_ip
  dns_nameservers = var.dns_nameservers
  ip_version      = 4
}

resource "openstack_networking_router_v2" "router" {
  count          = var.enable_router ? 1 : 0
  name           = "${var.network_name}-router"
  admin_state_up = true
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  count     = var.enable_router ? 1 : 0
  router_id = openstack_networking_router_v2.router[0].id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}
