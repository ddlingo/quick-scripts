project_name = "dev-sms"
domain_id    = "default"

federated_group_local_name = "SAP_Developers"
openstack_role_name        = "custom_project_admin"

bootstrap_admin_name       = "local_admin"
bootstrap_admin_password   = "changeme"

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

image_name   = "Ubuntu-22.04"
flavor_name  = "c4.m4"
keypair_name = "my-key"
