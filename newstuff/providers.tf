###########################################
# providers.tf
# OpenStack provider configuration
###########################################

provider "openstack" {
  auth_url    = var.os_auth_url
  user_name   = var.os_user_name
  password    = var.os_password
  tenant_name = var.os_tenant_name
  region      = var.os_region
}

variable "os_auth_url" {
  description = "OpenStack authentication URL"
  type        = string
}

variable "os_user_name" {
  description = "OpenStack username"
  type        = string
}

variable "os_password" {
  description = "OpenStack password"
  type        = string
  sensitive   = true
}

variable "os_tenant_name" {
  description = "OpenStack tenant/project name"
  type        = string
}

variable "os_region" {
  description = "OpenStack region name"
  type        = string
}
