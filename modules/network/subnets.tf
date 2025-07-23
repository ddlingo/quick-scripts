resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.context.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.context.name_prefix}-public-subnet"
    owner       = var.context.owner
    environment = var.context.environment
    managedby   = var.context.managed_by
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.context.region}a"

  tags = {
    Name        = "${var.context.name_prefix}-private-subnet"
    owner       = var.context.owner
    environment = var.context.environment
    managedby   = var.context.managed_by
  }
}
