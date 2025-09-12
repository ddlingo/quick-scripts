variable "project_name" {}
variable "domain_id" { default = "default" }
variable "federated_group_local_name" {}
variable "openstack_role_name" {}
variable "bootstrap_admin_name" { default = "" }
variable "bootstrap_admin_password" { default = "" }

# Example tags/context variables
variable "environment" {}
variable "owner" {}
variable "organization" {
  type = object({
    formatted = string
    friendly  = string
  })
}
variable "security_boundary" {
  type = object({
    formatted = string
    friendly  = string
  })
}
variable "business" {
  type = object({
    formatted = string
    friendly  = string
  })
}
variable "cloud_provider" {
  type = object({
    name      = string
    formatted = string
    friendly  = string
  })
}
variable "cloud_partition" {
  type = object({
    name      = string
    formatted = string
    friendly  = string
  })
}
variable "minor_security_boundary" {
  type = object({
    name      = string
    formatted = string
    friendly  = string
  })
}
variable "business_subsection" {
  type = object({
    name      = string
    formatted = string
    friendly  = string
  })
}
variable "account_identifier" {
  type = object({
    name      = string
    formatted = string
    friendly  = string
  })
}
variable "customer" {
  type = object({
    formatted = string
    friendly  = string
  })
}
variable "parent_domain_internal" {}
variable "parent_domain_external" {}

# Example compute/network variables
variable "image_name" {}
variable "flavor_name" {}
variable "keypair_name" {}
variable "os_cloud_name" {}
variable "os_region_name" {}
