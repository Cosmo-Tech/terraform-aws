resource "aws_s3_bucket" "bucket" {
  bucket = "cosmotech-states"
  region = var.region

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}