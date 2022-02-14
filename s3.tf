resource "aws_s3_bucket" "testS3" {
  bucket = "cass20220209-terraform-bucket"
  acl    = "private"

  versioning {
      enabled = true
  }

  lifecycle_rule {
    prefix = "image/"
    enabled = true

    noncurrent_version_expiration {
      days = 180
    }
  }

  tags = {
    "Name" = "terracass-s3.tf"
  }
}
