locals {
  autoscale_values = {
    "KUBERNETES_VERSION" = "v${aws_eks_cluster.cluster.version}.2"
    "CLUSTER_NAME"       = local.main_name
  }
}

resource "aws_eks_cluster" "cluster" {
  tags = local.tags

  name   = local.main_name
  region = var.cluster_region

  role_arn                      = var.iam_role_main
  deletion_protection           = true
  bootstrap_self_managed_addons = false

  upgrade_policy {
    support_type = "STANDARD"
  }

  compute_config {
    enabled       = true
    node_pools    = ["system"]
    node_role_arn = var.iam_role_eks_auto_mode
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
    subnet_ids = var.lan_subnet_ids

    endpoint_private_access = "true"
    endpoint_public_access  = "true"
  }

  depends_on = [
    var.iam_role_main,
    var.nat_id,
    var.wan_ig_id, # Be sure to have internet access
  ]
}


resource "aws_eks_addon" "vpc_cni" {
  tags = local.tags

  cluster_name = aws_eks_cluster.cluster.name
  region       = var.cluster_region

  addon_name = "vpc-cni"

  depends_on = [
    aws_eks_cluster.cluster,
  ]
}


resource "aws_eks_addon" "kube_proxy" {
  tags = local.tags

  cluster_name = aws_eks_cluster.cluster.name
  region       = var.cluster_region

  addon_name = "kube-proxy"

  depends_on = [
    aws_eks_cluster.cluster,
  ]
}


resource "aws_eks_addon" "coredns" {
  tags = local.tags

  cluster_name = aws_eks_cluster.cluster.name
  region       = var.cluster_region

  addon_name = "coredns"
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
  ]
}


resource "aws_eks_addon" "ebs_csi_driver" {
  tags = local.tags

  cluster_name                = aws_eks_cluster.cluster.name
  region                      = var.cluster_region
  addon_name                  = "aws-ebs-csi-driver"
  configuration_values        = null
  preserve                    = true
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  pod_identity_association {
    role_arn        = var.iam_role_main
    service_account = "ebs-csi-controller-sa"
  }

  depends_on = [
    aws_eks_cluster.cluster,
  ]
}


# Required for autoscale
resource "aws_eks_addon" "eks_pod_identity_agent" {
  tags = local.tags

  cluster_name                = aws_eks_cluster.cluster.name
  region                      = var.cluster_region
  addon_name                  = "eks-pod-identity-agent"
  configuration_values        = null
  preserve                    = true
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  # pod_identity_association {
  #   role_arn        = var.iam_role_main
  #   service_account = "ebs-csi-controller-sa"
  # }

  depends_on = [
    aws_eks_cluster.cluster,
  ]
}


# Storage class
resource "kubernetes_storage_class" "cosmotech-retain" {
  metadata {
    name = "cosmotech-retain"
  }
  storage_provisioner    = "ebs.csi.aws.com"
  reclaim_policy         = "Retain"
  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"

  depends_on = [
    aws_eks_addon.ebs_csi_driver,
  ]
}


# Autoscale
data "template_file" "autoscale" {
  template = templatefile("${path.module}/autoscale.yaml", local.autoscale_values)
}

resource "null_resource" "autoscale" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.autoscale.rendered}")}"
  }
  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.autoscale.rendered}\nEOF"
  }
}

resource "aws_eks_pod_identity_association" "autoscale" {
  cluster_name    = aws_eks_cluster.cluster.name
  namespace       = "kube-system"
  service_account = "cluster-autoscaler"
  role_arn        = var.iam_role_main
}