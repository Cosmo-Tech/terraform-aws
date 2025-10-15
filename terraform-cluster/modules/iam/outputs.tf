# output "role_arn" {
#   value = aws_iam_role.main.arn
# }

output "role_main" {
  value = aws_iam_role.main
}

output "role_eks_auto_mode" {
  value = data.aws_iam_role.eks_auto_mode
}