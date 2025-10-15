# output "subnet_ids" {
#   value = [aws_default_subnet.subnet1.id, aws_default_subnet.subnet2.id]
# }

# output "subnet1_id" {
#   value = aws_default_subnet.subnet1.id
# }

# output "subnet2_id" {
#   value = aws_default_subnet.subnet2.id
# }


# output "subnet_ids" {
#   value = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
# }

# output "subnet1_id" {
#   value = aws_subnet.subnet1.id
# }

# output "subnet2_id" {
#   value = aws_subnet.subnet2.id
# }



# output "subnet_ids" {
#   value = aws_subnet.subnet[*].id
# }

output "subnet_ids" {
  value = aws_subnet.lan_subnets[*].id
}


# output "route_id" {
#   value = aws_route.route.id
# }

# output "nat_gateway_ids" {
#   value = aws_nat_gateway.nat_gateways[*].id
# }

# output "nat_gateway_id1" {
#   value = aws_nat_gateway.nat_gateway1.id
# }

# output "nat_gateway_id2" {
#   value = aws_nat_gateway.nat_gateway2.id
# }