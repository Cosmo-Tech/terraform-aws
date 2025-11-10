variable "lan_subnet_ids" {
  type = list(string)
}

# variable "wan_subnet_id" {
#   type = string
# }

variable "wan_ig_id" {
  type = string
}

variable "nat_id" {
  type = string
}

variable "iam_role_main" {
  type = string
}

variable "iam_role_eks_auto_mode" {
  type = string
}

# variable "addons" {
#   type = map(object({
#     replica_count   = number
#     cpu_limit       = string
#     cpu_requests    = string
#     memory_limit    = string
#     memory_requests = string
#   }))
# }