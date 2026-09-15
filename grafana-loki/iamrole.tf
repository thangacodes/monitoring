# ======================
# IAM Role Creation:
# =======================

resource "aws_iam_role" "loki_s3_bucket" {
  name = "loki-s3-bucket-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "loki-s3-bucket"
    Environment = var.environment
    Owner       = var.owner
  }
}


# ====================
# IAM Policy
# ====================

resource "aws_iam_policy" "loki_s3_bucket" {
  name        = "loki-s3-bucket-access"
  description = "Allow Loki EC2 instance to access Loki S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ListLokiBucket"
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = aws_s3_bucket.loki.arn
      },
      {
        Sid    = "LokiObjectAccess"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = "${aws_s3_bucket.loki.arn}/*"
      }
    ]
  })
}

# ======================
# Attach policy to role
# ======================

resource "aws_iam_role_policy_attachment" "loki_s3_bucket" {
  role       = aws_iam_role.loki_s3_bucket.name
  policy_arn = aws_iam_policy.loki_s3_bucket.arn
}

# =======================
# EC2 Instance Profile
# =======================

resource "aws_iam_instance_profile" "loki_s3_bucket" {
  name = "loki-s3-bucket-instance-profile"
  role = aws_iam_role.loki_s3_bucket.name
  tags = {
    Name        = "loki-s3-bucket-instance-profile"
    Environment = var.environment
    Owner       = var.owner
  }
}
