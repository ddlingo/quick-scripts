resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name        = "${var.context.name_prefix}-natgw-eip"
    owner       = var.context.owner
    environment = var.context.environment
    managedby   = var.context.managed_by
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name        = "${var.context.name_prefix}-natgw"
    owner       = var.context.owner
    environment = var.context.environment
    managedby   = var.context.managed_by
  }

  depends_on = [aws_internet_gateway.igw]
}
