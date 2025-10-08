terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

## PROVIDERS
provider "aws" {
  region = "eu-west-1"
}


## VARIABLES
variable "cluster_name" {
  description = "The name of the Kubernetes cluster"
  type        = string
}


## MODULES
module "cluster" {
  source = "./modules/module-cluster"

  cluster_name = var.cluster_name
}


# module "storage-state" {
#   source = "./modules/module-storage-state"

# }