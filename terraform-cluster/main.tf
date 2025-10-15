## Resource group
module "rg" {
  source = "./modules/rg"

  additional_tags = var.additional_tags
  cluster_name    = var.cluster_name
  cluster_stage   = var.cluster_stage
  cluster_region  = var.cluster_region
}


## IAM
module "iam" {
  source = "./modules/iam"

  additional_tags = var.additional_tags
  cluster_name    = var.cluster_name
  cluster_stage   = var.cluster_stage
  cluster_region  = var.cluster_region
}


## Kubernetes cluster network
module "network" {
  source = "./modules/network"

  additional_tags = var.additional_tags
  cluster_name    = var.cluster_name
  cluster_stage   = var.cluster_stage
  cluster_region  = var.cluster_region
}


## Kubernetes cluster
module "cluster" {
  source = "./modules/cluster"

  additional_tags = var.additional_tags
  cluster_name    = var.cluster_name
  cluster_stage   = var.cluster_stage
  cluster_region  = var.cluster_region

  iam_role_main   = module.iam.role_main.arn
  iam_role_eks_auto_mode   = module.iam.role_eks_auto_mode.arn
  subnet_ids = module.network.subnet_ids
  # route_id = module.network.route_id
  # nat_gateway_id1 = module.network.nat_gateway_id1
  # nat_gateway_id2 = module.network.nat_gateway_id2
  # subnet1_id = module.network.subnet1_id
  # subnet2_id = module.network.subnet2_id
}


## Kubernetes cluster nodes
module "nodes" {
  source = "./modules/nodes"

  additional_tags = var.additional_tags
  cluster_name    = var.cluster_name
  cluster_stage   = var.cluster_stage
  cluster_region  = var.cluster_region

  cluster_id = module.cluster.cluster_id

  iam_role_main   = module.iam.role_main.arn
  subnet_ids = module.network.subnet_ids
  # route_id = module.network.route_id

  # nat_gateway_id1 = module.network.nat_gateway_id1
  # nat_gateway_id2 = module.network.nat_gateway_id2
  # subnet1_id = module.network.subnet1_id
  # subnet2_id = module.network.subnet2_id
}

