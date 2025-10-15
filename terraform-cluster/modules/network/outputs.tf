output "subnet_ids" {
  value = aws_subnet.lan_subnets[*].id
}