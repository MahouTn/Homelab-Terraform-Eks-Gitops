resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.cidr_public_subnets)
  cidr_block              = var.cidr_public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.azs[count.index]

  tags = {
    Name = "homelab-eks"
  }
}


resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  count             = length(var.cidr_public_subnets)
  cidr_block        = var.cidr_private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "homelab-eks"
  }
}