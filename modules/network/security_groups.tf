resource "aws_security_group" "ingress_sg" {
  name        = "${var.context.name_prefix}-ingress-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.context.name_prefix}-ingress-sg"
    owner       = var.context.owner
    environment = var.context.environment
    managedby   = var.context.managed_by
  }
}

resource "aws_security_group" "egress_sg" {
  name        = "${var.context.name_prefix}-egress-sg"
  description = "Allow all outbound traffic"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.context.name_prefix}-egress-sg"
    owner       = var.context.owner
    environment = var.context.environment
    managedby   = var.context.managed_by
  }
}
