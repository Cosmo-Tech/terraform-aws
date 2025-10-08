# ## Module where all variables are defined (to avoid variables code duplication between root and submodules)
# module "var" {
#   source = "./modules/var"

#   cluster_name = var.cluster_name
# }


## Kubernetes cluster
module "cluster" {
  source = "./modules/module-cluster"

  cluster_name = var.cluster_name
  cluster_stage = var.cluster_stage
}


## Terraform state storage
# module "storage-state" {
#   source = "./modules/module-storage-state"

# }