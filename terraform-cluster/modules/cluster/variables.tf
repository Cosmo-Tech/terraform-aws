# variable "subnet1_id" {
#   type = string
# }

# variable "subnet2_id" {
#   type = string
# }

variable "subnet_ids" {
  type = list(any)
}

# variable "route_id" {
#   type = string
# }

# variable "nat_gateway_id1" {
#   type = string
# }

# variable "nat_gateway_id2" {
#   type = string
# }

variable "iam_role_main" {
  type = string
}

variable "iam_role_eks_auto_mode" {
  type = string
}


