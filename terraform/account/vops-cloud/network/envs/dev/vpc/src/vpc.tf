resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags ={
      Name="vpc-dev" 
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
         Name ="igw-dev"
  }
}
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id
  tags =  {
          Name ="rtb-dev"
  }
}
resource "aws_route" "route_public" {
  route_table_id         = aws_route_table.rtb_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" "rtb_associations_public" {
  for_each       = { for subnet in var.public_subnets : subnet.name => subnet }
  subnet_id      = aws_subnet.public_subnets[each.value.name].id
  route_table_id = aws_route_table.rtb_public.id
}
resource "aws_subnet" "public_subnets" {
  for_each                = { for subnet in var.public_subnets : subnet.name => subnet }
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.value.zone
  map_public_ip_on_launch = true
  cidr_block              = each.value.cidr_blocks
  tags =  {
          Name ="subnet-dev-pub"
  }
}
resource "aws_subnet" "private_subnets" {
  for_each                = { for subnet in var.private_subnets : subnet.name => subnet }
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.value.zone
  map_public_ip_on_launch = false
  cidr_block              = each.value.cidr_blocks
  tags =  {
          Name ="subnet-dev-prv"
  }
}
