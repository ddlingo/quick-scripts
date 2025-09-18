provider "openstack" {
  auth_url    = var.os_auth_url
  user_name   = var.os_user_name
  password    = var.os_password
  tenant_name = var.os_project_name
  domain_name = var.os_user_domain_name
  region      = var.os_region
}

variable "os_auth_url" {
  description = "Authentication URL for OpenStack Identity (Keystone) service"
  type        = string
}
variable "os_user_name" {
  description = "Username for OpenStack authentication"
  type        = string
}
variable "os_password" {
  description = "Password for OpenStack authentication"
  type        = string
  sensitive   = true
}
variable "os_project_name" {
  description = "OpenStack project (tenant) name"
  type        = string
}
variable "os_user_domain_name" {
  description = "Domain name for the OpenStack user"
  type        = string
  default     = "Default"
}
variable "os_region" {
  description = "OpenStack region name"
  type        = string
  default     = "RegionOne"
}
