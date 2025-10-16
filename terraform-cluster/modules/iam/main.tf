resource "aws_iam_role" "main" {
  tags = local.tags

  name = "cosmotech-${local.main_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Principal = {
          Service = ["eks.amazonaws.com", "ec2.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policies" {
  for_each = toset([
    "AmazonEKSClusterPolicy",
    "AmazonEKSWorkerNodePolicy",
    "AmazonEKS_CNI_Policy",
    "AmazonEC2ContainerRegistryReadOnly",
    "AmazonEKSBlockStoragePolicy",
    "AmazonEKSComputePolicy",
    "AmazonEKSLoadBalancingPolicy",
    "AmazonEKSNetworkingPolicy",
  ])

  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
  role       = aws_iam_role.main.name

  depends_on = [
    aws_iam_role.main,
  ]
}


data "aws_iam_role" "eks_auto_mode" {
  name = "AmazonEKSAutoNodeRole"
}
