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

variable "enable_router" {
  type        = bool
  description = "If true, create a router and attach subnet"
  default     = true
}
