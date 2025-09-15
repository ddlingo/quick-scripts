############################################
# main.tf — OpenStack Orchestration Context
############################################

locals {
  name_prefix = var.name_prefix != null ? var.name_prefix : join("-", compact([
    var.org_slug,
    var.env_slug,
    var.app_slug
  ]))

  tags = merge({
    Application  = var.app_slug
    Environment  = var.env_slug
    Owner        = var.owner
    CostCenter   = var.cost_center
    Stack        = var.tag_stack
    Purpose      = var.tag_purpose
    Compliance   = var.tag_compliance
    ManagedBy    = "terraform"
    Terraform    = "true"
  }, var.extra_tags)
}

locals {
  enable_core_iam         = var.enable_core_iam
  enable_federation_roles = var.enable_federation_roles
  enable_readonly_role    = var.enable_readonly_role
  enable_auditor_role     = var.enable_auditor_role
}

# No resources here. All logic is in openstack-federation.tf
