## IAM
module "iam" {
  source = "./modules/iam"

  cluster_name   = var.cluster_name
  cluster_stage  = var.cluster_stage
  cluster_region = var.cluster_region
}


## Kubernetes cluster network
module "network" {
  source = "./modules/network"

  cluster_name   = var.cluster_name
  cluster_stage  = var.cluster_stage
  cluster_region = var.cluster_region
}


## Kubernetes cluster
module "cluster" {
  source = "./modules/cluster"

  cluster_name   = var.cluster_name
  cluster_stage  = var.cluster_stage
  cluster_region = var.cluster_region

  iam_role   = module.iam.role_arn
  subnet1_id = module.network.subnet1_id
  subnet2_id = module.network.subnet2_id
}


## Kubernetes cluster nodes
module "nodes" {
  source = "./modules/nodes"

  cluster_name   = var.cluster_name
  cluster_stage  = var.cluster_stage
  cluster_region = var.cluster_region

  iam_role   = module.iam.role_arn
  subnet_ids = module.network.subnet_ids
  # subnet1_id = module.network.subnet1_id
  # subnet2_id = module.network.subnet2_id
}

