resource "aws_iam_role" "role" {
  name = "cosmotech-${local.main_name}"
  tags = local.tags

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


# # Cluster permissions
# resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.role.name

#   depends_on = [
#     aws_iam_role.role,
#   ]
# }

# # Nodes groups permissions
# resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.role.name

#   depends_on = [
#     aws_iam_role.role,
#   ]
# }

# resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.role.name

#   depends_on = [
#     aws_iam_role.role,
#   ]
# }

# resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.role.name

#   depends_on = [
#     aws_iam_role.role,
#   ]
# }



# --- --- --- --- --- --- --- --- --- --- ---
# Policies usages: 
# AmazonEKSClusterPolicy              = EKS cluster requirement
# AmazonEKSWorkerNodePolicy           = EKS node groups requirement
# AmazonEKS_CNI_Policy                = EKS node groups requirement
# AmazonEC2ContainerRegistryReadOnly  = EKS node groups requirement
# AmazonEKSBlockStoragePolicy         = EKS auto mode requirement
# AmazonEKSComputePolicy              = EKS auto mode requirement
# AmazonEKSLoadBalancingPolicy        = EKS auto mode requirement
# AmazonEKSNetworkingPolicy           = EKS auto mode requirement
# --- --- --- --- --- --- --- --- --- --- ---


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
  role       = aws_iam_role.role.name

  depends_on = [
    aws_iam_role.role,
  ]
}

