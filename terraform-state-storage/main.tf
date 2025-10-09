resource "aws_s3_bucket" "cosmotech_states" {
  bucket = "cosmotech-states"

  lifecycle {
    prevent_destroy = true
  }
}