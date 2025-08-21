output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [for subnet in aws_subnet.private_subnets : subnet.id]
}

output "public_subnets" {
  description = "Public subnets"
  value       = aws_subnet.public_subnets
}

output "private_subnets" {
  description = "Private subnets"
  value       = aws_subnet.private_subnets
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat_gateway.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.rtb_public.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.nat_gateway.id
}