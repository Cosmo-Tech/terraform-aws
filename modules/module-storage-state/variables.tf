variable "tags" {
  type = object({
    vendor      = string
    stage       = string
    customer    = string
    project     = string
    cost_center = string
  })
}

variable "container_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "tenant_sp_object_id" {
  type = string
}

variable "deployment_type" {
  type = string
}

variable "admin_enabled" {
  type = bool
}

variable "quarantine_policy_enabled" {
  type = bool
}

variable "data_endpoint_enabled" {
  type = bool
}

variable "public_network_access_enabled" {
  type = bool
}

variable "zone_redundancy_enabled" {
  type = bool
}

variable "trust_policy" {
  type = bool
}

variable "retention_policy_days" {
  type = number
}

variable "kubernetes_tenant_namespace" {
  type = string
}