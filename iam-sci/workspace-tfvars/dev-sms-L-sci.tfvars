# OpenStack provider (clouds.yaml) settings
os_cloud_name  = "sci-dev"
os_region_name = "eu-de-1"

# Project/IAM variables
project_name                = "dev-sms"
domain_id                   = "default"
federated_group_local_name  = "SAP_Developers"
openstack_role_name         = "custom_project_admin"
bootstrap_admin_name        = "local_admin"
bootstrap_admin_password    = "changeme"

# Context/tagging variables
environment = "dev"
owner       = "your.name"

organization = {
  formatted = "acme-corp"
  friendly  = "Acme Corp"
}
security_boundary = {
  formatted = "prod"
  friendly  = "Production"
}
business = {
  formatted = "it"
  friendly  = "IT"
}
cloud_provider = {
  name      = "openstack"
  formatted = "openstack"
  friendly  = "OpenStack"
}
cloud_partition = {
  name      = "eu-west"
  formatted = "eu-west"
  friendly  = "EU West"
}
minor_security_boundary = {
  name      = "minor"
  formatted = "minor"
  friendly  = "Minor"
}
business_subsection = {
  name      = "app"
  formatted = "app"
  friendly  = "App"
}
account_identifier = {
  name      = "devsms"
  formatted = "dev-sms"
  friendly  = "Dev SMS"
}
customer = {
  formatted = "customer"
  friendly  = "Customer"
}
parent_domain_internal = "scs.internal"
parent_domain_external = "scs.sap"

# Network/compute variables
image_name            = "Ubuntu-22.04"
flavor_name           = "c4.m4"
keypair_name          = "my-key"
sms_net_cidr          = "192.168.199.0/24"
bind_net_cidr         = "10.47.35.0/24"
dns_nameservers       = ["1.1.1.1"]
external_network_name = "FloatingIP-external-iaas-01"

# Example: extra security groups for ports (can be empty)
extra_security_groups = []
