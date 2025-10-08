terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "tfstates-${var.cluster_stage}-${var.cluster_name}"
    key    = "path/to/my/key"
    region = var.cluster_region
  }
}

provider "aws" {
  region = "eu-west-1"
  # region = var.cluster_region
}