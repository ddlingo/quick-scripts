###########################################
# remote-backend.tf
# S3 remote backend configuration for Terraform state
###########################################

terraform {
  backend "s3" {
    bucket         = var.s3_bucket_name
    key            = var.s3_state_key
    region         = var.s3_region
    dynamodb_table = var.s3_dynamodb_table
    encrypt        = true
    profile        = var.s3_profile
  }
}
