
resource "aws_resourcegroups_group" "rg" {
  name = local.main_name
  tags = local.tags

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
