# locals {
#   main_name = "eks-${var.cluster_stage}-${var.cluster_name}"
# }

resource "aws_eks_cluster" "cluster" {
  name = local.main_name

  access_config {
    authentication_mode = "API"
  }

  # role_arn = aws_iam_role.cluster.arn
  # role_arn = var.aws_iam_role
  # role_arn = module.iam.role
  role_arn = local.main_name

  # version  = "1.31" # Automatically triggred if not given

  vpc_config {
    subnet_ids = [
      # aws_default_subnet.subnet1.id,
      # aws_default_subnet.subnet2.id,
      # module.network.subnet1_id,
      # module.network.subnet2_id,
      # local.subnet1_id,
      # local.subnet2_id,
      module.network.subnet1_id,
      module.network.subnet2_id,
      # var.subnet1_id,
      # var.subnet2_id,
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  # depends_on = [
  #   aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  # ]
}


# variable "subnet1_id" {
#   type = string
# }

# variable "subnet2_id" {
#   type = string
# }