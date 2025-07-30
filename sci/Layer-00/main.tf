provider "openstack" {
  cloud = "sci-monsoon3"
}

module "network" {
  source           = "../modules/network"
  network_name     = var.network_name
  subnet_name      = var.subnet_name
  cidr             = var.cidr
  gateway_ip       = var.gateway_ip
  dns_nameservers  = var.dns_nameservers
}
