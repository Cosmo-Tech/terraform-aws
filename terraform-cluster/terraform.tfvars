cluster_name   = "devops1"
cluster_stage  = "dev"
cluster_region = "eu-west-3"

# You can add or remove tags according to your needs (the following list is just an example)
# default tags will be registered: "rg" (resource group), "stage" (based on given stage), "vendor" (="cosmotech")
additional_tags = {
  cost_center = "n/a"
}


# For non-Cosmo Tech clusters, a domain name must be setted here.
# Otherwise, cosmotech.com will be used.
alternative_domain_name = ""