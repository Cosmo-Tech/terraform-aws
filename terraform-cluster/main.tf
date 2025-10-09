## DNS
module "dns" {
  source = "./modules/dns"

  cluster_name = var.cluster_name
  cluster_stage = var.cluster_stage
  cluster_region = var.cluster_region
}


## IAM
module "iam" {
  source = "./modules/iam"

  cluster_name = var.cluster_name
  cluster_stage = var.cluster_stage
  cluster_region = var.cluster_region
}


## Kubernetes cluster network
module "cluster-network" {
  source = "./modules/cluster-network"

  cluster_name = var.cluster_name
  cluster_stage = var.cluster_stage
  cluster_region = var.cluster_region
}


## Kubernetes cluster instance
module "cluster" {
  source = "./modules/cluster"

  cluster_name = var.cluster_name
  cluster_stage = var.cluster_stage
  cluster_region = var.cluster_region
}


## Kubernetes cluster nodes
module "cluster-nodes" {
  source = "./modules/cluster-nodes"

  cluster_name = var.cluster_name
  cluster_stage = var.cluster_stage
  cluster_region = var.cluster_region
}

