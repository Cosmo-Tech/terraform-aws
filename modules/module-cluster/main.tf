locals {
  main_name = "eks-${var.cluster_name}"
}


resource "aws_default_subnet" "default_subnet1" {
  availability_zone = "eu-west-1a"
}

resource "aws_default_subnet" "default_subnet2" {
  availability_zone = "eu-west-1b"
}

# resource "aws_subnet" "subnet1" {
#   vpc_id     = aws_default_subnet.default_subnet.id
#   cidr_block = "10.0.1.0/24"
# }

# resource "aws_subnet" "subnet2" {
#   vpc_id     = aws_default_subnet.default_subnet.id
#   cidr_block = "10.0.2.0/24"
# }

resource "aws_eks_cluster" "cluster" {
  name = local.main_name

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.cluster.arn
  # version  = "1.31" # Automatically triggred if not given

  vpc_config {
    subnet_ids = [
      aws_default_subnet.default_subnet1.id,
      aws_default_subnet.default_subnet2.id,
      # aws_subnet.az2.id,
      # aws_subnet.az3.id,
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role" "cluster" {
  name = local.main_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}



# resource "aws_eks_node_group" "cluster" {
#   cluster_name    = aws_eks_cluster.cluster.name
#   node_group_name = local.main_name
#   node_role_arn   = aws_iam_role.cluster.arn
#   subnet_ids      = aws_subnet.cluster[*].id

#   scaling_config {
#     desired_size = 1
#     max_size     = 2
#     min_size     = 1
#   }

#   update_config {
#     max_unavailable = 1
#   }

#   # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#   # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#   depends_on = [
#     aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
#   ]
# }