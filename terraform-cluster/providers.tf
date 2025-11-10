terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.17.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38.0"
    }
  }
  backend "s3" {}
}

provider "aws" {}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = local.main_name
}