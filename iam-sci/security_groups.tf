########################################
# Security Groups
########################################

resource "openstack_networking_secgroup_v2" "intra" {
  name        = "intra-project"
  description = "Allow intra-project communication"
}

# Allow ICMP between members of the SG
resource "openstack_networking_secgroup_rule_v2" "intra_icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_group_id   = openstack_networking_secgroup_v2.intra.id
  security_group_id = openstack_networking_secgroup_v2.intra.id
}

# Allow SSH between members of the SG
resource "openstack_networking_secgroup_rule_v2" "intra_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id   = openstack_networking_secgroup_v2.intra.id
  security_group_id = openstack_networking_secgroup_v2.intra.id
}

# Allow DNS between members of the SG
resource "openstack_networking_secgroup_rule_v2" "intra_dns_udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 53
  port_range_max    = 53
  remote_group_id   = openstack_networking_secgroup_v2.intra.id
  security_group_id = openstack_networking_secgroup_v2.intra.id
}

resource "openstack_networking_secgroup_rule_v2" "intra_dns_tcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 53
  port_range_max    = 53
  remote_group_id   = openstack_networking_secgroup_v2.intra.id
  security_group_id = openstack_networking_secgroup_v2.intra.id
}

# Optional: Allow SSH from anywhere (tighten to VPN or CIDR in prod)
resource "openstack_networking_secgroup_rule_v2" "ssh_from_any" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.intra.id
}
