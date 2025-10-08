locals {
  main_name = "tfstates-${var.cluster_stage}-${var.cluster_name}"
}


## Install a helm chart s3 to host future tenants states