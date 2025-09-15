###########################################
# terraform.tfvars
# Example values for variables
###########################################

org_slug       = "sci"
env_slug       = "dev"
app_slug       = "iam-orchestration"

owner          = "platform-team"
cost_center    = "CC12345"

tag_stack      = "platform"
tag_purpose    = "iam-management"
tag_compliance = "none"

extra_tags = {
  Department   = "Cloud"
  Automation   = "Terraform"
  Confidential = "false"
}

# Example: Mapping federated groups to roles
federated_group_to_role = {
  "keycloak-group1"     = "member"
  "keycloak-admins"     = "admin"
}

project_id = "your-openstack-project-id"

# S3 backend config
s3_bucket_name    = "your-terraform-state-bucket"
s3_state_key      = "openstack-federation/terraform.tfstate"
s3_region         = "us-east-1"
s3_dynamodb_table = "your-terraform-lock-table"
s3_profile        = "default"
