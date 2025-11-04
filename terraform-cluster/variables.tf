locals {
  main_name = "eks-${var.cluster_stage}-${var.cluster_name}"

  tags = merge(
    var.additional_tags,
    {
      rg     = local.main_name
      stage  = var.cluster_stage
      vendor = "cosmotech"
    },
  )

  domain_name = var.alternative_domain_name == null ? var.alternative_domain_name : "aws.platform.cosmotech.com"
  # domain_name = "aws.platform.cosmotech.com"
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
}

variable "cluster_stage" {
  description = "Kubernetes cluster stage"
  type        = string

  validation {
    condition     = contains(["test", "dev", "dmo", "ppd", "prd"], var.cluster_stage)
    error_message = "Valid values for 'cluster_stage' are: \n- test\n- dev\n- dmo\n- ppd\n- prd"
  }
}

variable "cluster_region" {
  description = "Kubernetes cluster region"
  type        = string
}

variable "additional_tags" {
  description = "List of tags"
  type        = map(string)
}

variable "alternative_domain_name" {
  description = "Altenative domain name for non Cosmo Tech deployments"
  type        = string
}