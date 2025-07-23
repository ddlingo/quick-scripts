module "base_context" {
  source = "../modules/terraform-null-context"

  account_id             = var.account_id
  build_user             = var.build_user
  business               = var.business.name
  customer               = var.customer.name
  include_customer_label = var.include_customer_label
  environment            = var.environment
  organization           = var.organization.name
  label_order            = var.label_order
  owner                  = var.owner
  partition              = var.partition
  region                 = var.region
  root_module            = var.root_module
  security_boundary      = var.security_boundary.name

  environment_values = {
    kv = {
      organization_formatted         = var.organization.formatted
      organization_friendly_name     = var.organization.friendly
      security_boundary_formatted    = var.security_boundary.formatted
      security_boundary_friendly_name = var.security_boundary.friendly
      business_formatted             = var.business.formatted
      business_friendly_name         = var.business.friendly
    }
  }

  tags = [
    { name = "SecurityBoundary", value = "security_boundary", required = true },
    { name = "Business", value = "business", required = true }
  ]

  locals = null
}

module "network" {
  source  = "./modules/network"
  context = module.base_context.context
}
