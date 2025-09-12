variable "openstack_cloud" {
  description = "Name of the OpenStack cloud as defined in clouds.yaml"
  type        = string
}

variable "domain_id" {
  description = "The OpenStack domain ID (usually 'default')"
  type        = string
}

variable "project_name" {
  description = "The name of the OpenStack project"
  type        = string
}

variable "federated_group_local_name" {
  description = "The name of the federated group in Keystone"
  type        = string
}

variable "openstack_role_names" {
  description = "List of role names to assign to the group"
  type        = list(string)
}
