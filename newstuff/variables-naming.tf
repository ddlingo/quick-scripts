###########################################
# variables-naming.tf
# Naming, toggles, mapping, and project id
###########################################

variable "name_prefix" {
  description = "Optional override for generated name prefix"
  type        = string
  default     = null
}

variable "enable_core_iam" {
  description = "Toggle to enable core IAM logic"
  type        = bool
  default     = true
}

variable "enable_federation_roles" {
  description = "Toggle to create federation-related role assignments"
  type        = bool
  default     = true
}

variable "enable_readonly_role" {
  description = "Toggle to assign read-only role"
  type        = bool
  default     = false
}

variable "enable_auditor_role" {
  description = "Toggle to assign auditor role"
  type        = bool
  default     = false
}

variable "federated_group_to_role" {
  description = "Mapping of federated group name to OpenStack role name"
  type        = map(string)
  default     = {}
}

variable "project_id" {
  description = "OpenStack project ID for role assignments"
  type        = string
}
