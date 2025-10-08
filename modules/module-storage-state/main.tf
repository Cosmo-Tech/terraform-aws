locals {
  main_name = "tfstates-${var.cluster_stage}-${var.cluster_name}"
}


resource "aws_s3_bucket" "example" {
  bucket = local.main_name
}