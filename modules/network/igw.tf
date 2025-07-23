resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.context.name_prefix}-igw"
    owner       = var.context.owner
    environment = var.context.environment
    managedby   = var.context.managed_by
  }
}
