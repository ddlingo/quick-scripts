/*
  Description: Environment-specific configurations required for module setup; Declaration of providers, backend settings, and remote state
  Comments: The contents of this file should not be modified by Operators
*/

# Keycloak Terraform Provider
provider "keycloak" {
  client_id     = "terraform"
  client_secret = var.keycloak_terraform_client_secret
  url           = var.keycloak_uri
  base_path     = var.keycloak_wildfly ? "/auth" : null
}

# AWS S3 Terraform Backend (SCI-compatible)
terraform {
  backend "s3" {
    bucket                      = "sms-dev-terraform"
    key                         = "apps/keycloak/${terraform.workspace}/layer-00.tfstate"
    region                      = "eu-de-1"
    skip_region_validation      = true
    skip_credentials_validation = true
    endpoint                    = "https://objectstore-3.eu-de-1.cloud.sap"
    force_path_style            = true
    profile                     = "sci-external-domain-management"
    encrypt                     = false
  }
}

# Remote State
locals {
  management = {
    layer_00 = data.terraform_remote_state.management_layer_00.outputs
  }
  base_context = local.management_layer_00.base_context
}

data "terraform_remote_state" "management_layer_00" {
  backend = "s3"
  config = {
    bucket                      = "sms-dev-terraform"
    key                         = "management/${terraform.workspace}/layer-00.tfstate"
    region                      = "eu-de-1"
    skip_region_validation      = true
    skip_credentials_validation = true
    endpoint                    = "https://objectstore-3.eu-de-1.cloud.sap"
    force_path_style            = true
    profile                     = "sci-external-domain-management"
    encrypt                     = false
  }
}