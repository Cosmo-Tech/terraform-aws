

# data "aws_region" "current" {

# }

## Kubernetes cluster
module "cluster" {
  source = "./modules/module-cluster"

  cluster_name = var.cluster_name
  cluster_stage = var.cluster_stage
  cluster_region = var.cluster_region
}


# Terraform state storage
module "storage-state" {
  source = "./modules/module-storage-state"

  cluster_name = var.cluster_name
  cluster_stage = var.cluster_stage
  cluster_region = var.cluster_region
}