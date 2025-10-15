resource "aws_eks_cluster" "cluster" {
  name = local.main_name
  tags = local.tags

  role_arn                      = var.iam_role
  deletion_protection           = true
  bootstrap_self_managed_addons = false

  upgrade_policy {
    support_type = "STANDARD"
  }

  compute_config {
    enabled       = true
    node_pools    = ["system"]
    node_role_arn = var.iam_role
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
    subnet_ids = var.subnet_ids
  }

  depends_on = [
    var.iam_role,
    var.subnet_ids,
  ]
}

resource "aws_eks_addon" "addon-vpc_cni" {
  tags = local.tags

  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "vpc-cni"

  depends_on = [
    aws_eks_cluster.cluster,
  ]
}

resource "aws_eks_addon" "addon-kube_proxy" {
  tags = local.tags

  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "kube-proxy"

  depends_on = [
    aws_eks_cluster.cluster,
  ]
}

resource "aws_eks_addon" "addon-coredns" {
  tags = local.tags

  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "coredns"
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
    # aws_eks_addon.addon-kube_proxy,
    # aws_eks_addon.addon-vpc_cni,
  ]
}




# # Admin users
# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterAdminPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = var.iam_role

#   depends_on = [
#     var.iam_role,
#     aws_eks_cluster.cluster,
#   ]
# }

# resource "aws_eks_access_policy_association" "cluster_admin" {
#   cluster_name  = local.main_name
#   policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#   # principal_arn = "arn:aws:sts::${data.aws_caller_identity.current.id}:assumed-role/AWSServiceRoleForAmazonEKS/{{SessionName}}"
#   principal_arn = var.iam_role

#   access_scope {
#     type       = "cluster"
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.cluster_AmazonEKSClusterAdminPolicy,
#   ]
# }
