resource "aws_eks_cluster" "cluster" {
  name     = local.main_name
  role_arn = var.iam_role

  access_config {
    authentication_mode = "API"
  }

  vpc_config {
    subnet_ids = [
      var.subnet1_id,
      var.subnet2_id,
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  # depends_on = [
  #   aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  # ]
}


