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

variable "cluster_id" {
  type = string
}

variable "node_groups" {
  type = map(object({
    tier         = string
    machine_type = string
    min          = number
    max          = number
  }))
}