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

  iam_role_main          = module.iam.role_main.arn
  iam_role_eks_auto_mode = module.iam.role_eks_auto_mode.arn
  lan_subnet_ids         = module.network.lan_subnet_ids
  # wan_subnet_id  = module.network.wan_subnet_id
  nat_id    = module.network.nat_id
  wan_ig_id = module.network.wan_ig_id
}


## Kubernetes cluster nodes
module "nodes" {
  source = "./modules/nodes"

  additional_tags = var.additional_tags
  cluster_name    = var.cluster_name
  cluster_stage   = var.cluster_stage
  cluster_region  = var.cluster_region

  cluster_id = module.cluster.cluster_id

  iam_role_main  = module.iam.role_main.arn
  lan_subnet_ids = module.network.lan_subnet_ids
  # wan_subnet_id  = module.network.wan_subnet_id
  nat_id    = module.network.nat_id
  wan_ig_id = module.network.wan_ig_id

  node_groups = {
    monitoring = {
      machine_type = "t3.small"
      min          = 1
      max          = 2
      tier         = "monitoring"
    }

    services = {
      machine_type = "t3a.xlarge"
      min          = 1
      max          = 3
      tier         = "services"
    }

    db = {
      machine_type = "t3a.large"
      min          = 1
      max          = 4
      tier         = "db"
    }

    basic = {
      machine_type = "c5d.xlarge"
      min          = 1
      max          = 4
      tier         = "basic"
    }

    highcpu = {
      machine_type = "c5d.18xlarge"
      min          = 0
      max          = 3
      tier         = "highcpu"
    }

    highmemory = {
      machine_type = "r5ad.4xlarge"
      min          = 0
      max          = 3
      tier         = "highmemory"
    }
  }
}

