variable "subnet_ids" {
  type = list(any)
}

# variable "nat_gateway_id1" {
#   type = string
# }

# variable "nat_gateway_id2" {
#   type = string
# }

variable "iam_role" {
  type = string
}

variable "cluster_id" {
  type = string
}