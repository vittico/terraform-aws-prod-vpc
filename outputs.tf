# VPC outputs
output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_arn" {
  value = aws_vpc.this.arn
}

output "vpc_object" {
  value = aws_vpc.this
}

# Subnets outputs
output "public_subnets_ids" {
  value = aws_subnet.public.*.id
}

output "public_subnet_object" {
  value = aws_subnet.public
}

output "private_subnets_ids" {
  value = aws_subnet.private.*.id
}

output "private_subnet_object" {
  value = aws_subnet.public
}

# IG outputs
output "igw_id" {
  value = aws_internet_gateway.this.id
}

output "igw_object" {
  value = aws_internet_gateway.this
}

# EIP outputs
output "eip_objects" {
  value = aws_eip.this.*
}

# Default route outputs
output "default_rt_id" {
  value = aws_route.this.id
}

output "default_rt_object" {
  value = aws_route.this
}

# NAT gateway outputs
output "natgw_ids" {
  value = aws_nat_gateway.this.*.id
}

output "natgw_object" {
  value = aws_nat_gateway.this
}

# Route Tables outputs
output "rt_ids" {
  value = aws_route_table.this.*.id
}

output "rt_objects" {
  value = aws_route_table.this
}