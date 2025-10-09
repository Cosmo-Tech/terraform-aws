# locals {
#   main_name = "eks-${var.cluster_stage}-${var.cluster_name}"
# }


## DNS
module "dns" {
  source = "./modules/dns"

  cluster_name = var.cluster_name
  cluster_stage = var.cluster_stage
  cluster_region = var.cluster_region
  # main_name = "eks-${var.cluster_stage}-${var.cluster_name}"
  # main_name = var.main_name
}


## IAM
module "iam" {
  source = "./modules/iam"

  cluster_name = var.cluster_name
  cluster_stage = var.cluster_stage
  cluster_region = var.cluster_region
  # main_name = "eks-${var.cluster_stage}-${var.cluster_name}"
}


## Kubernetes cluster network
module "network" {
  source = "./modules/network"

  cluster_name = var.cluster_name
  cluster_stage = var.cluster_stage
  cluster_region = var.cluster_region
  # main_name = "eks-${var.cluster_stage}-${var.cluster_name}"
}


## Kubernetes cluster
module "cluster" {
  source = "./modules/cluster"

  cluster_name = var.cluster_name
  cluster_stage = var.cluster_stage
  cluster_region = var.cluster_region
  # iam_role = module.iam.role
  # subnet1_id = module.network.subnet1_id
  # subnet2_id = module.network.subnet2_id
  # main_name = "eks-${var.cluster_stage}-${var.cluster_name}"
}


## Kubernetes cluster nodes
module "nodes" {
  source = "./modules/nodes"

  cluster_name = var.cluster_name
  cluster_stage = var.cluster_stage
  cluster_region = var.cluster_region
  # main_name = "eks-${var.cluster_stage}-${var.cluster_name}"
}

