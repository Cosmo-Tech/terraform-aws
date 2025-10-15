variable "subnet_ids" {
  type = list(any)
}

variable "iam_role_main" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "node_groups" {
  description = "Map of node pool definitions"
  type = map(object({
    machine_type = string
    min          = number
    max          = number
    tier         = string
  }))
}