output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}
output "nat_gateway_ids" {
  description = "The IDs of the NAT gateways"
  value       = aws_nat_gateway.main[*].id
}