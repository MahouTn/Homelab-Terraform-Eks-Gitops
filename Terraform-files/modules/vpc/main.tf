resource "aws_vpc" "main" {
  cidr_block       = var.cidr_vpc
  instance_tenancy = "default"

  tags = {
    Name = "homelab-eks"
  }
}

