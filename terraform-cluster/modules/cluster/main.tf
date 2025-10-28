resource "aws_eks_cluster" "cluster" {
  tags = local.tags

  name   = local.main_name
  region = var.cluster_region

  role_arn                      = var.iam_role_main
  deletion_protection           = true
  bootstrap_self_managed_addons = false

  upgrade_policy {
    support_type = "STANDARD"
  }

  compute_config {
    enabled       = true
    node_pools    = ["system"]
    node_role_arn = var.iam_role_eks_auto_mode
  }

  kubernetes_network_config {
    service_ipv4_cidr = "172.16.0.0/16"
    ip_family         = "ipv4"
    elastic_load_balancing {
      enabled = true
    }
  }

  storage_config {
    block_storage {
      enabled = true
    }
  }

  access_config {
    authentication_mode = "API"
  }

  vpc_config {
    subnet_ids = var.lan_subnet_ids

    endpoint_private_access = "true"
    endpoint_public_access  = "true"
  }

  depends_on = [
    var.iam_role_main,
    # var.lan_subnet_ids,
    # var.wan_subnet_id, # Be sure to have internet access
    var.nat_id,
    var.wan_ig_id, # Be sure to have internet access
  ]
}

# resource "aws_eks_addon" "addons" {
#   for_each = var.addons

#   tags = local.tags

#   cluster_name = aws_eks_cluster.cluster.name
#   region       = var.cluster_region

#   addon_name   = each.key

#   configuration_values = jsonencode({
#     replicaCount = each.value.replica_count
#     resources = {
#       limits = {
#         cpu    = "${each.value.cpu_limit}"
#         memory = "${each.value.memory_limit}"
#       }
#       requests = {
#         cpu    = "${each.value.cpu_requests}"
#         memory = "${each.value.memory_requests}"
#       }
#     }
#   })

#   depends_on = [
#     aws_eks_cluster.cluster,
#   ]
# }

resource "aws_eks_addon" "addon-vpc_cni" {
  tags = local.tags

  cluster_name = aws_eks_cluster.cluster.name
  region       = var.cluster_region

  addon_name = "vpc-cni"

  depends_on = [
    aws_eks_cluster.cluster,
  ]
}

resource "aws_eks_addon" "addon-kube_proxy" {
  tags = local.tags

  cluster_name = aws_eks_cluster.cluster.name
  region       = var.cluster_region

  addon_name = "kube-proxy"

  depends_on = [
    aws_eks_cluster.cluster,
  ]
}

resource "aws_eks_addon" "addon-coredns" {
  tags = local.tags

  cluster_name = aws_eks_cluster.cluster.name
  region       = var.cluster_region

  addon_name = "coredns"

  # addon_version               = "v1.10.1-eksbuild.1"
  # resolve_conflicts_on_create = "OVERWRITE"

  configuration_values = jsonencode({
    replicaCount = 1
    resources = {
      limits = {
        cpu    = "100m"
        memory = "150Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "150Mi"
      }
    }
  })

  depends_on = [
    aws_eks_cluster.cluster,
  ]
}

# resource "aws_eks_addon" "addon-ebs_csi_driver" {
#   tags = local.tags

#   cluster_name = aws_eks_cluster.cluster.name
#   region       = var.cluster_region

#   addon_name = "aws-ebs-csi-driver"

#   depends_on = [
#     aws_eks_cluster.cluster,
#   ]
# }


