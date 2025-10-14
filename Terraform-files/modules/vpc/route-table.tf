resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.internet_route
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "homelab-eks"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  count  = length(var.azs)

  route {
    cidr_block     = var.internet_route
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name = "homelab-eks-${count.index + 1}"
  }
}


resource "aws_route_table_association" "public_subnet_route" {
  count          = length(var.cidr_public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_subnet_route" {
  count          = length(var.cidr_private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}