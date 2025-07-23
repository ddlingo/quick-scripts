resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "${var.context.name_prefix}-vpc"
    owner       = var.context.owner
    environment = var.context.environment
    managedby   = var.context.managed_by
  }
}
