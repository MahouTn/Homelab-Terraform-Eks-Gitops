resource "aws_eip" "nat_gw_eip" {
  domain = "vpc"
  count  = length(var.azs)

  tags = {
    Name = "homelab-eks-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "main" {
  count         = length(var.azs)
  allocation_id = aws_eip.nat_gw_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "homelab-eks-${count.index + 1}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}
