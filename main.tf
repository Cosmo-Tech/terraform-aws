## Kubernetes cluster
module "cluster" {
  source = "./modules/module-cluster"

  cluster_name = var.cluster_name
  cluster_stage = var.cluster_stage
  cluster_region = var.cluster_region
}


# Terraform state storage of Kubernetes cluster
module "cluster-storage-state" {
  source = "./modules/module-cluster-storage-state"

  cluster_name = var.cluster_name
  cluster_stage = var.cluster_stage
  cluster_region = var.cluster_region
}


# # Terraform state storage of Cosmo Tech Tenant
# module "tenant-storage-state" {
#   source = "./modules/module-tenant-storage-state"


# }