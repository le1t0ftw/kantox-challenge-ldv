locals {
  bucket_name = lower("${var.bucket_name}")
}

resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "this_ownership" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "this_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.this_ownership]
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "bucket_access" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  count = var.create_bucket && length(keys(var.versioning)) > 0 ? 1 : 0

  bucket                = aws_s3_bucket.this.id
  mfa                   = try(var.versioning["mfa"], null)
  versioning_configuration {
    # Valid values: "Enabled" or "Suspended"
    status = try(var.versioning["enabled"] ? "Enabled" : "Suspended", tobool(var.versioning["status"]) ? "Enabled" : "Suspended", title(lower(var.versioning["status"])))

    # Valid values: "Enabled" or "Disabled"
    mfa_delete = try(tobool(var.versioning["mfa_delete"]) ? "Enabled" : "Disabled", title(lower(var.versioning["mfa_delete"])), null)
  }
}