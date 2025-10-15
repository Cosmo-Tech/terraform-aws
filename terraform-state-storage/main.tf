resource "aws_s3_bucket" "cosmotech_states" {
  bucket = "cosmotech-states"
  region = var.region

  lifecycle {
    prevent_destroy = true
  }
}