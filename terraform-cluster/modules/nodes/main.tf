# db
# - Node size: Standard_D4ads_v5 -> t3a.large (! AWS downgraded in comparison of Azure !)
# - cpu : 4         -> 4
# - ram : 16 Go     -> 8 Go

# monitoring
# - Node size: Standard_D2ads_v5 -> t3.small (! AWS downgraded in comparison of Azure !)
# - cpu : 2         -> 2
# - ram : 8 Go      -> 2 Go

# highmemory
# - Node size: Standard_E16ads_v5 -> r5ad.4xlarge
# - cpu : 16
# - ram : 128 Go

# basic
# - Node size: Standard_F4s_v2 -> c5d.xlarge
# - cpu : 4
# - ram : 8 Go

# services
# - Node size: Standard_B4ms -> t3a.xlarge
# - cpu : 4
# - ram : 16 Go

# highcpu
# - Node size: Standard_F72s_v2 -> c5d.18xlarge
# - cpu : 72
# - ram : 144 Go

# system
# - Node size: Standard_DS2_v2 -> t3a.large
# - cpu : 2
# - ram : 7 Go


locals {
  node_name_prefix = "cosmotech-node-${local.main_name}"
}

resource "aws_eks_node_group" "node_groups" {
  for_each = var.node_groups

  tags = local.tags

  cluster_name = local.main_name
  region       = var.cluster_region

  node_group_name = "${local.main_name}-${each.value.tier}"
  node_role_arn   = var.iam_role_main
  subnet_ids      = ["${var.lan_subnet_ids[0]}"] # Force nodes to be on only one subnet. This is a quick fix to avoid pods unscheduled due to their persistents storages not on the same region zone that the node.

  instance_types = ["${each.value.machine_type}"]
  ami_type       = "AL2023_x86_64_STANDARD"

  labels = {
    "cosmotech.com/tier" = "${each.value.tier}"
  }

  taint {
    key    = "vendor"
    value  = "cosmotech"
    effect = "NO_SCHEDULE"
  }

  scaling_config {
    desired_size = each.value.min
    min_size     = each.value.min
    max_size     = each.value.max
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    var.iam_role_main,
    var.cluster_id,
    var.nat_id,
    var.wan_ig_id, # Be sure to have internet access
  ]
}
