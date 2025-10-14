output "vpc_id" {
  value       = aws_vpc.main.id
  description = "vpc id"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "public subnets id"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "private subnets id"
}