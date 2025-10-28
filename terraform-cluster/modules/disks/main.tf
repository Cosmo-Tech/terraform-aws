
resource "aws_resourcegroups_group" "rg" {
  tags = local.tags

  name   = local.main_name
  region = var.cluster_region

  resource_query {
    query = <<JSON
      {
        "ResourceTypeFilters": [
          "AWS::AllSupported"
        ],
        "TagFilters": [
          {
            "Key": "rg",
            "Values": ["${local.main_name}"]
          }
        ]
      }
    JSON
  }
}
