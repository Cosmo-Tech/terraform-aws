output "subnet_ids" {
  value = [aws_default_subnet.subnet1.id, aws_default_subnet.subnet2.id]
}

output "subnet1_id" {
  value = aws_default_subnet.subnet1.id
}

output "subnet2_id" {
  value = aws_default_subnet.subnet2.id
}