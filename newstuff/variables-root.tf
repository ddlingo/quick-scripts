###########################################
# variables-root.tf
# Root-level and backend variables for OpenStack orchestration
###########################################

variable "org_slug" {
  description = "Organization short name (e.g., sci, acme)"
  type        = string
}

variable "env_slug" {
  description = "Environment short name (e.g., dev, stage, prod)"
  type        = string
}

variable "app_slug" {
  description = "Application short name (e.g., iam, network, orchestration)"
  type        = string
}

variable "owner" {
  description = "Owner of this deployment (person/team identifier)"
  type        = string
}

variable "cost_center" {
  description = "Cost center tag value"
  type        = string
}

variable "tag_stack" {
  description = "Stack name for tagging"
  type        = string
}

variable "tag_purpose" {
  description = "Purpose tag for resources"
  type        = string
}

variable "tag_compliance" {
  description = "Compliance tag (e.g., SOX, PCI, HIPAA)"
  type        = string
}

variable "extra_tags" {
  description = "Map of additional custom tags"
  type        = map(string)
  default     = {}
}

variable "s3_bucket_name" {
  description = "S3 bucket for Terraform remote state"
  type        = string
}

variable "s3_state_key" {
  description = "S3 object key for the state file (e.g., path/to/terraform.tfstate)"
  type        = string
}

variable "s3_region" {
  description = "AWS region for the S3 bucket"
  type        = string
}

variable "s3_dynamodb_table" {
  description = "DynamoDB table for state locking (optional)"
  type        = string
  default     = null
}

variable "s3_profile" {
  description = "AWS CLI profile for S3 backend (optional)"
  type        = string
  default     = null
}
