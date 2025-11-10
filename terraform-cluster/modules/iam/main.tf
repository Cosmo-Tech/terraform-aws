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
          Service = [
            "eks.amazonaws.com",
            "ec2.amazonaws.com",
            "pods.eks.amazonaws.com"
          ]
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


resource "aws_iam_role_policy_attachment" "policies_servicesroles" {
  for_each = toset([
    "AmazonEBSCSIDriverPolicy",
  ])

  policy_arn = "arn:aws:iam::aws:policy/service-role/${each.value}"
  role       = aws_iam_role.main.name

  depends_on = [
    aws_iam_role.main,
  ]
}


data "aws_iam_role" "eks_auto_mode" {
  name = "AmazonEKSAutoNodeRole"
}





# data "aws_iam_policy_document" "eks_cluster_autoscaler_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     condition {
#       test     = "StringEquals"
#       variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
#       values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
#     }

#     principals {
#       identifiers = [aws_iam_openid_connect_provider.eks.arn]
#       type        = "Federated"
#     }
#   }
# }

# resource "aws_iam_role" "eks_cluster_autoscaler" {
#   assume_role_policy = data.aws_iam_policy_document.eks_cluster_autoscaler_assume_role_policy.json
#   name               = "eks-cluster-autoscaler"
# }

resource "aws_iam_policy" "eks_cluster_autoscaler" {
  name = "eks-cluster-autoscaler"

  policy = jsonencode({
    Statement = [{
      Action = [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeLaunchTemplateVersions",
        "autoscaling:DescribeScalingActivities",
        "eks:DescribeNodegroup",
        "ec2:DescribeImages",
        "ec2:DescribeInstanceTypes",
        "ec2:GetInstanceTypesFromInstanceRequirements"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_autoscaler_attach" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.eks_cluster_autoscaler.arn
}





# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "autoscaling:DescribeAutoScalingGroups",
#         "autoscaling:DescribeAutoScalingInstances",
#         "autoscaling:DescribeLaunchConfigurations",
#         "autoscaling:DescribeScalingActivities",
#         "autoscaling:SetDesiredCapacity",
#         "autoscaling:TerminateInstanceInAutoScalingGroup",
#         "eks:DescribeNodegroup"
#       ],
#       "Resource": ["arn:aws:autoscaling:${YOUR_CLUSTER_AWS_REGION}:${YOUR_AWS_ACCOUNT_ID}:autoScalingGroup:*:autoScalingGroupName/${YOUR_ASG_NAME}"]
#     }
#   ]
# }






# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "autoscaling:DescribeAutoScalingGroups",
#         "autoscaling:DescribeAutoScalingInstances",
#         "autoscaling:DescribeLaunchConfigurations",
#         "autoscaling:DescribeScalingActivities",
#         "ec2:DescribeImages",
#         "ec2:DescribeInstanceTypes",
#         "ec2:DescribeLaunchTemplateVersions",
#         "ec2:GetInstanceTypesFromInstanceRequirements",
#         "eks:DescribeNodegroup"
#       ],
#       "Resource": ["*"]
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "autoscaling:SetDesiredCapacity",
#         "autoscaling:TerminateInstanceInAutoScalingGroup"
#       ],
#       "Resource": ["*"]
#     }
#   ]
# }