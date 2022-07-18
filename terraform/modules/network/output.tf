output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}

output "eip_addresses" {
  value = aws_eip.eip.*.public_ip
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnets" {
  value = aws_subnet.private_subnet.*.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.natgw.*.id
}

output "aws_route53_zone_id" {
  description = "The DNS Zone ID"
  value       = aws_route53_zone.this.id
}
