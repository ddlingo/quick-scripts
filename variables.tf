variable "account_id" {
  type = string
}

variable "build_user" {
  type = string
}

variable "business" {
  type = object({
    name      = string
    formatted = string
    friendly  = string
  })
}

variable "customer" {
  type = object({
    name = string
  })
}

variable "include_customer_label" {
  type = bool
}

variable "environment" {
  type = string
}

variable "organization" {
  type = object({
    name      = string
    formatted = string
    friendly  = string
  })
}

variable "label_order" {
  type = list(string)
}

variable "owner" {
  type = string
}

variable "partition" {
  type = string
}

variable "region" {
  type = string
}

variable "root_module" {
  type = string
}

variable "security_boundary" {
  type = object({
    name      = string
    formatted = string
    friendly  = string
  })
}
