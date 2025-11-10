## Resource group
module "rg" {
  source = "./modules/rg"

  additional_tags = var.additional_tags
  cluster_name    = var.cluster_name
  cluster_stage   = var.cluster_stage
  cluster_region  = var.cluster_region
  # domain_name     = local.domain_name
  alternative_domain_name = ""
}


## IAM
module "iam" {
  source = "./modules/iam"

  additional_tags = var.additional_tags
  cluster_name    = var.cluster_name
  cluster_stage   = var.cluster_stage
  cluster_region  = var.cluster_region
  # domain_name     = local.domain_name
  alternative_domain_name = ""
}


## Kubernetes cluster network
module "network" {
  source = "./modules/network"

  additional_tags = var.additional_tags
  cluster_name    = var.cluster_name
  cluster_stage   = var.cluster_stage
  cluster_region  = var.cluster_region
  # domain_name     = local.domain_name
  alternative_domain_name = ""
}


## Kubernetes cluster
module "cluster" {
  source = "./modules/cluster"

  additional_tags = var.additional_tags
  cluster_name    = var.cluster_name
  cluster_stage   = var.cluster_stage
  cluster_region  = var.cluster_region
  # domain_name     = local.domain_name
  alternative_domain_name = ""

  iam_role_main          = module.iam.role_main.arn
  iam_role_eks_auto_mode = module.iam.role_eks_auto_mode.arn
  lan_subnet_ids         = module.network.lan_subnet_ids
  # wan_subnet_id  = module.network.wan_subnet_id
  nat_id    = module.network.nat_id
  wan_ig_id = module.network.wan_ig_id

  # addons = {
  #   coredns = {
  #     replica_count   = 1
  #     cpu_limit       = "100m"
  #     cpu_requests    = "100m"
  #     memory_limit    = "150Mi"
  #     memory_requests = "150Mi"
  #   }
  #   kube-proxy = {
  #     replica_count   = 1
  #     cpu_limit       = "100m"
  #     cpu_requests    = "100m"
  #     memory_limit    = "150Mi"
  #     memory_requests = "150Mi"
  #   }
  #   vpc-cni = {
  #     replica_count   = 1
  #     cpu_limit       = "100m"
  #     cpu_requests    = "100m"
  #     memory_limit    = "150Mi"
  #     memory_requests = "150Mi"
  #   }
  #   aws-ebs-csi-driver = {
  #     replica_count   = 1
  #     cpu_limit       = "100m"
  #     cpu_requests    = "100m"
  #     memory_limit    = "150Mi"
  #     memory_requests = "150Mi"
  #   }
  # }
}


## Kubernetes cluster nodes
module "nodes" {
  source = "./modules/nodes"

  additional_tags = var.additional_tags
  cluster_name    = var.cluster_name
  cluster_stage   = var.cluster_stage
  cluster_region  = var.cluster_region
  # domain_name     = local.domain_name
  alternative_domain_name = ""

  cluster_id = module.cluster.cluster_id

  iam_role_main  = module.iam.role_main.arn
  lan_subnet_ids = module.network.lan_subnet_ids
  # lan_subnet_ids = module.network.lan_subnet_id1
  # wan_subnet_id  = module.network.wan_subnet_id
  nat_id    = module.network.nat_id
  wan_ig_id = module.network.wan_ig_id



  # Machine types below are setted from:
  #  - Burstable = false (otherwise, autoscaler isn't working)
  #  - Zone availability (There are 2 kinds of AWS instances type: NN.size (=Intel) & NNa.size (=AMD). Most of AMD types are not available accross all the world while Intel type are available almost everywhere)
  node_groups = {
    monitoring = {
      tier = "monitoring"
      # machine_type = "t3a.micro"
      machine_type = "m5.large"
      min          = 1
      # min          = 0
      max = 2
    }
    services = {
      tier = "services"
      # machine_type = "t3a.micro"
      machine_type = "m5.xlarge"
      min          = 1
      max          = 3
    }
    db = {
      tier = "db"
      # machine_type = "t3a.micro"
      machine_type = "m5.xlarge"
      min          = 1
      max          = 4
    }
    basic = {
      tier = "basic"
      # machine_type = "t3a.micro"
      machine_type = "m5.xlarge"
      min          = 1
      max          = 4
    }
    highmemory = {
      tier         = "highmemory"
      machine_type = "t3a.micro"
      # machine_type = "r5.4xlarge"
      min = 0
      max = 3
    }
    highcpu = {
      tier         = "highcpu"
      machine_type = "t3a.micro"
      # machine_type = "c5d.18xlarge"
      min = 0
      max = 3
    }
  }
}


## DNS
module "dns" {
  source = "./modules/dns"

  additional_tags = var.additional_tags
  cluster_name    = var.cluster_name
  cluster_stage   = var.cluster_stage
  cluster_region  = var.cluster_region

  # domain_name = var.alternative_domain_name ? var.alternative_domain_name : "${var.cluster_name}.aws.platform.cosmotech.com"

  main_name               = local.main_name
  domain_name             = local.domain_name
  alternative_domain_name = ""
}
