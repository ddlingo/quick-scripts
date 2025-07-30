variable "account_id" {
  type        = string
  description = "Account ID for the environment"
}

variable "build_user" {
  type        = string
  description = "User or system initiating the build"
}

variable "business" {
  type = object({
    name      = string
    formatted = string
    friendly  = string
  })
  description = "Business context object"
}

variable "customer" {
  type = object({
    name = string
  })
  description = "Customer information object"
}

variable "include_customer_label" {
  type        = bool
  description = "Include the customer label in resource tags/labels"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
}

variable "organization" {
  type = object({
    name      = string
    formatted = string
    friendly  = string
  })
  description = "Organization context object"
}

variable "label_order" {
  type        = list(string)
  description = "Order in which labels are applied"
}

variable "owner" {
  type        = string
  description = "Owner of the deployment"
}

variable "partition" {
  type        = string
  description = "Partition (e.g., 'aws', 'openstack')"
}

variable "region" {
  type        = string
  description = "Region for resource deployment"
}

variable "root_module" {
  type        = string
  description = "Name of the root module"
}

variable "security_boundary" {
  type = object({
    name      = string
    formatted = string
    friendly  = string
  })
  description = "Security boundary context"
}

# Existing networking variables

variable "network_name" {
  type        = string
  description = "Name of the OpenStack network"
}

variable "subnet_name" {
  type        = string
  description = "Name of the OpenStack subnet"
}

variable "cidr" {
  type        = string
  description = "CIDR block for the subnet"
}

variable "gateway_ip" {
  type        = string
  description = "Gateway IP for the subnet"
}

variable "dns_nameservers" {
  type        = list(string)
  description = "List of DNS nameservers"
}
