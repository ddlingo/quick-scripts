variable "boundry" {
  description = "Boundary for the naming convention"
  type        = string
}

variable "product" {
  description = "Product for the naming convention"
  type        = string
}

variable "function" {
  description = "Function for the naming convention"
  type        = string
  default     = ""
}

variable "project_id" {
  description = "OpenStack Project ID"
  type        = string
}

variable "group_role_mapping" {
  description = "A map of group names to lists of role names to assign in this project"
  type        = map(list(string))
}

# Added for Keycloak provider support in environment.tf
variable "keycloak_terraform_client_secret" {
  description = "Keycloak Terraform client secret"
  type        = string
  sensitive   = true
}

variable "keycloak_uri" {
  description = "Keycloak base URI"
  type        = string
}

variable "keycloak_wildfly" {
  description = "Whether Keycloak is running on Wildfly"
  type        = bool
  default     = false
}