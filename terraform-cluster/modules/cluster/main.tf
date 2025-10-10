resource "aws_eks_cluster" "cluster" {
  name                = local.main_name
  role_arn            = var.iam_role
  deletion_protection = true

  compute_config {
    enabled = true
  }

  kubernetes_network_config {
    elastic_load_balancing {
      enabled = true
    }
  }

  storage_config {
    block_storage {
      enabled = true
    }
  }


  bootstrap_self_managed_addons = false

  access_config {
    authentication_mode = "API"
  }

  vpc_config {
    subnet_ids = [
      var.subnet1_id,
      var.subnet2_id,
    ]
  }

  tags = local.tags



  depends_on = [
    var.iam_role,
  ]
}


 