locals {
  environment_values = {
    kv = {
      environment                         = var.environment
      owner                               = var.owner
      project_name                        = var.project_name
      organization_formatted              = var.organization.formatted
      organization_friendly_name          = var.organization.friendly
      security_boundary_formatted         = var.security_boundary.formatted
      security_boundary_friendly_name     = var.security_boundary.friendly
      business_formatted                  = var.business.formatted
      business_friendly_name              = var.business.friendly
      cloud_provider                      = var.cloud_provider.name
      cloud_provider_formatted            = var.cloud_provider.formatted
      cloud_provider_friendly_name        = var.cloud_provider.friendly
      cloud_partition                     = var.cloud_partition.name
      cloud_partition_formatted           = var.cloud_partition.formatted
      cloud_partition_friendly_name       = var.cloud_partition.friendly
      minor_security_boundary             = var.minor_security_boundary.name
      minor_security_boundary_formatted   = var.minor_security_boundary.formatted
      minor_security_boundary_friendly_name = var.minor_security_boundary.friendly
      business_subsection                 = var.business_subsection.name
      business_subsection_formatted       = var.business_subsection.formatted
      business_subsection_friendly_name   = var.business_subsection.friendly
      account_identifier                  = var.account_identifier.name
      account_identifier_formatted        = var.account_identifier.formatted
      account_identifier_friendly_name    = var.account_identifier.friendly
      customer_formatted                  = var.customer.formatted
      customer_friendly_name              = var.customer.friendly
      parent_domain_internal              = var.parent_domain_internal
      parent_domain_external              = var.parent_domain_external
    }
  }

  tags = [
    { name = "MinorSecurityBoundary", value = "minor_security_boundary", required = false },
    { name = "BusinessSubsection",   value = "business_subsection",     required = false },
    { name = "AccountIdentifier",    value = "account_identifier",      required = false },
  ]
}

# Example compute resource using tags/context as metadata
resource "openstack_compute_instance_v2" "sms_designate" {
  name        = "sms-designate"
  image_name  = var.image_name
  flavor_name = var.flavor_name
  key_pair    = var.keypair_name

  network {
    port = openstack_networking_port_v2.sms.id
  }

  metadata = local.environment_values.kv
}

output "context" {
  value = local.environment_values.kv
}
