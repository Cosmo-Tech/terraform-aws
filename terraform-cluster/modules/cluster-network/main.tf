locals {
  main_name = "eks-${var.cluster_stage}-${var.cluster_name}"
}

resource "aws_default_subnet" "default_subnet1" {
  availability_zone = "${var.cluster_region}a"
}

resource "aws_default_subnet" "default_subnet2" {
    availability_zone = "${var.cluster_region}b"
}