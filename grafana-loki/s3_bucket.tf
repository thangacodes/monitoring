resource "aws_s3_bucket" "loki" {
  bucket = "${lower(var.project_name)}-loki-${var.aws_region}"
  tags = {
    Name        = "${var.project_name}-loki"
    Environment = var.environment
    Purpose     = "Loki log storage"
  }
}

# --------------------------
# Block all public access
# --------------------------

resource "aws_s3_bucket_public_access_block" "loki" {
  bucket = aws_s3_bucket.loki.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -------------------------
# Enable versioning
# --------------------------

resource "aws_s3_bucket_versioning" "loki" {
  bucket = aws_s3_bucket.loki.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ---------------------------
# Server-side encryption
# ---------------------------

resource "aws_s3_bucket_server_side_encryption_configuration" "loki" {
  bucket = aws_s3_bucket.loki.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ----------------------
# Lifecycle
# ----------------------

resource "aws_s3_bucket_lifecycle_configuration" "loki" {
  bucket = aws_s3_bucket.loki.id

  rule {
    id     = "loki-retention"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 15
    }

    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}
