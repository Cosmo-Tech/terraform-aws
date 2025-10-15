# #     cosmotech.com/tiers : db
# #     cosmotech.com/tiers : monitoring
# #     cosmotech.com/tiers : highmemory
# #     cosmotech.com/tiers : basic
# #     cosmotech.com/tiers : services
# #     cosmotech.com/tiers : highcpu
# # db
# # - Node size: Standard_D4ads_v5 -> t3a.large (! AWS downgraded in comparison of Azure !)
# # - cpu : 4         -> 4
# # - ram : 16 Go     -> 8 Go

# # monitoring
# # - Node size: Standard_D2ads_v5 -> t3.small (! AWS downgraded in comparison of Azure !)
# # - cpu : 2         -> 2
# # - ram : 8 Go      -> 2 Go

# # highmemory
# # - Node size: Standard_E16ads_v5 -> r5ad.4xlarge
# # - cpu : 16
# # - ram : 128 Go

# # basic
# # - Node size: Standard_F4s_v2 -> c5d.xlarge
# # - cpu : 4
# # - ram : 8 Go

# # services
# # - Node size: Standard_B4ms -> t3a.xlarge
# # - cpu : 4
# # - ram : 16 Go

# # highcpu
# # - Node size: Standard_F72s_v2 -> c5d.18xlarge
# # - cpu : 72
# # - ram : 144 Go

# # system
# # - Node size: Standard_DS2_v2 -> t3a.large
# # - cpu : 2
# # - ram : 7 Go

# # kubernetes_nodepool_system_type             = "Standard_A2_v2"
# # kubernetes_basic_compute_type               = "Standard_F4s_v2"
# # kubernetes_highcpu_compute_type             = "Standard_F72s_v2"
# # kubernetes_highmemory_compute_type          = "Standard_E16ads_v5"
# # kubernetes_monitoring_type                  = "Standard_D2ads_v5"
# # kubernetes_services_type                    = "Standard_B4ms"
# # kubernetes_db_type                          = "Standard_D4ads_v5"
# # kubernetes_tekton_compute_type              = "Standard_D2ads_v5"
# # kubernetes_max_basic_compute_instances      = 5
# # kubernetes_max_highcpu_compute_instances    = 2
# # kubernetes_max_highmemory_compute_instances = 3
# # kubernetes_max_monitoring_instances         = 10
# # kubernetes_max_services_instances           = 5
# # kubernetes_min_db_instances                 = 2
# # kubernetes_max_db_instances                 = 6
# # kubernetes_min_monitoring_instances         = 1
# # kubernetes_min_services_instances           = 2
# # kubernetes_min_highmemory_compute_instances = 0
# # kubernetes_min_highcpu_compute_instances    = 0
# # kubernetes_min_basic_compute_instances      = 1
# # kubernetes_min_system_instances             = 3
# # kubernetes_min_tekton_compute_instances     = 1
# # kubernetes_max_system_instances             = 6
# # kubernetes_max_tekton_compute_instances     = 2
# # kubernetes_max_monitoring_pods              = 110
# # kubernetes_max_db_pods                      = 110
# # kubernetes_max_services_pods                = 110
# # kubernetes_max_highmemory_pods              = 110
# # kubernetes_max_highcpu_pods                 = 110
# # kubernetes_max_basic_pods                   = 110
# # kubernetes_max_system_pods                  = 110
# # kubernetes_max_tekton_pods                  = 110
# # kubernetes_monitoring_os_disk_size          = 128
# # kubernetes_db_os_disk_size                  = 128
# # kubernetes_services_os_disk_size            = 128
# # kubernetes_highmemory_os_disk_size          = 128
# # kubernetes_highcpu_os_disk_size             = 128
# # kubernetes_basic_os_disk_size               = 128
# # kubernetes_system_os_disk_size              = 128
# # kubernetes_tekton_os_disk_size              = 128
# # kubernetes_system_enable_auto_scaling       = true
# # kubernetes_basic_enable_auto_scaling        = true
# # kubernetes_highcpu_enable_auto_scaling      = true
# # kubernetes_highmemory_enable_auto_scaling   = true
# # kubernetes_services_enable_auto_scaling     = true
# # kubernetes_db_enable_auto_scaling           = true
# # kubernetes_monitoring_enable_auto_scaling   = true
# # kubernetes_tekton_enable_auto_scaling       = true


# # name
# # region
# # os
# # cpu
# # ram
# # disk
# # network


# locals {
#   node_name_prefix = "cosmotech-node-${local.main_name}"
#   # image_id  = "ami-0bc691261a82b32bc" # Ubuntu 24 (64-bit (x86))
#   # image_id = data.aws_ami.image.image_id

# }


# # data "aws_ami" "image" {
# #   # Ubuntu 24 (64-bit (x86))

# #   owners      = ["amazon"]
# #   most_recent = true
# #   region      = var.cluster_region

# #   filter {
# #     name   = "architecture"
# #     values = ["x86_64"]
# #   }

# #   filter {
# #     name   = "name"
# #     values = ["ubuntu/images/hvm-ssd/ubuntu*"]
# #   }

# #   filter {
# #     name   = "name"
# #     values = ["ubuntu-eks*24*server*"] # https://cloud-images.ubuntu.com/aws-eks/ -> ubuntu-eks/k8s_1.33/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20250612
# #   }
# # }



# # resource "aws_launch_template" "template_node-db" {
# #   tags = local.tags

# #   name = "${local.node_name_prefix}-db"

# #   region   = var.cluster_region
# #   image_id = data.aws_ami.image.image_id

# #   disable_api_stop        = true
# #   disable_api_termination = true

# #   instance_type = "t3a.large"

# #   metadata_options {
# #     http_endpoint               = "enabled"
# #     http_tokens                 = "required"
# #     http_put_response_hop_limit = 1
# #     # instance_metadata_tags      = "enabled"
# #   }

# #   monitoring {
# #     enabled = false
# #   }
# # }

# resource "aws_eks_node_group" "node_group-db" {
#   tags = local.tags

#   cluster_name = local.main_name

#   node_group_name = "${local.main_name}-db"
#   node_role_arn   = var.iam_role
#   subnet_ids      = var.subnet_ids

#   instance_types = ["t3a.large"]
#   ami_type       = "AL2023_x86_64_STANDARD"

#   labels = {
#     "cosmotech.com/tier" = "db"
#   }

#   taint {
#     key    = "vendor"
#     value  = "cosmotech"
#     effect = "NO_SCHEDULE"
#   }

#   # launch_template {
#   #   id      = aws_launch_template.template_node-db.id
#   #   version = aws_launch_template.template_node-db.default_version
#   # }

#   scaling_config {
#     desired_size = 1
#     min_size     = 1
#     max_size     = 6
#   }

#   lifecycle {
#     ignore_changes = [launch_template]
#   }

#   update_config {
#     max_unavailable = 1
#   }

#   depends_on = [
#     var.iam_role,
#     var.cluster_id,
#     # aws_launch_template.template_node-db,
#     # var.nat_gateway_id1,
#     # var.nat_gateway_id2,
#     var.subnet_ids,
#   ]
# }