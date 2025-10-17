output "lan_subnet_ids" {
  value = aws_subnet.lan_subnets[*].id
}

output "wan_subnet_id" {
  value = aws_subnet.wan_subnet.id
}

output "wan_ig_id" {
  value = aws_internet_gateway.wan_ig.id
}

output "nat_id" {
  value = aws_nat_gateway.nat.id
}