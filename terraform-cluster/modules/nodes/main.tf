#     cosmotech.com/tiers : db
#     cosmotech.com/tiers : monitoring
#     cosmotech.com/tiers : highmemory
#     cosmotech.com/tiers : basic
#     cosmotech.com/tiers : services
#     cosmotech.com/tiers : highcpu
# db
# - Node size: Standard_D4ads_v5
# - cpu : 4
# - ram : 16 Go

# monitoring
# - Node size: Standard_D2ads_v5
# - cpu : 2
# - ram : 8 Go

# highmemory
# - Node size: Standard_E16ads_v5
# - cpu : 16
# - ram : 128 Go

# basic
# - Node size: Standard_F4s_v2
# - cpu : 4
# - ram : 8 Go

# services
# - Node size: Standard_B4ms
# - cpu : 4
# - ram : 16 Go

# highcpu
# - Node size: Standard_F72s_v2
# - cpu : 72
# - ram : 144 Go

# system
# - Node size: Standard_DS2_v2
# - cpu : 2
# - ram : 7 Go


# name
# region
# os
# cpu
# ram
# disk
# network


locals {
  node_name_prefix = "cosmotech-node-${local.main_name}"
  # image_id  = "ami-0bc691261a82b32bc" # Ubuntu 24 (64-bit (x86))
  image_id = data.aws_ami.image.image_id

}


data "aws_ami" "image" {
  # Ubuntu 24 (64-bit (x86))

  owners      = ["amazon"]
  most_recent = true
  region      = var.cluster_region

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu*"]
  }
}



resource "aws_launch_template" "template_node-db" {
  name     = "${local.node_name_prefix}-db"
  region   = var.cluster_region
  image_id = local.image_id

  disable_api_stop        = true
  disable_api_termination = true

  instance_requirements {
    local_storage_types = ["ssd"]

    memory_mib {
      min = 16384
      max = 16384
    }

    vcpu_count {
      min = 4
      max = 4
    }

    total_local_storage_gb {
      min = 128
      max = 128
    }
  }
}

resource "aws_eks_node_group" "node_group-db" {
  cluster_name    = local.main_name
  node_group_name = "${local.main_name}-db"
  node_role_arn   = var.iam_role
  subnet_ids      = var.subnet_ids

  labels {
    "cosmotech.com/tier" = "db"
  }

  taint {
    key = "vendor"
    value = "cosmotech"
    effect = "NoSchedule"
  }

  launch_template {
    id      = aws_launch_template.template_node-db.id
    version = aws_launch_template.template_node-db.default_version
  }

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  lifecycle {
    ignore_changes = [launch_template]
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    var.iam_role,
    aws_launch_template.template_node-db,
  ]
}