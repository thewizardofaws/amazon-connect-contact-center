resource "aws_s3_bucket" "call_recordings" {
  bucket = "${var.s3_bucket_name}"
  acl    = "private" # Setting ACL to private [2][8].

  # Enable versioning [2]
  versioning {
    enabled = true
  }

  # Enable server-side encryption (optional, but recommended)
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Add lifecycle rules for managing storage costs (optional) [2]
  lifecycle_rule {
    id     = "expire_old_recordings"
    enabled = true

    expiration {
      days = 365 # Expire after 365 days
    }

    noncurrent_version_expiration {
      days = 90 # Expire non-current versions after 90 days
    }
  }

  tags = {
    Name        = "${var.s3_bucket_name}"
    Environment = "${var.environment}"
  }
}

# Bucket policy for secure access
resource "aws_s3_bucket_policy" "call_recordings_policy" {
  bucket = aws_s3_bucket.call_recordings.id
  policy = data.aws_iam_policy_document.call_recordings_policy_document.json
}

data "aws_iam_policy_document" "call_recordings_policy_document" {
  statement {
    sid    = "AllowConnectAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.connect_instance_name}-connect-role"] # replace with the actual connect role
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject"
    ]

    resources = [
      aws_s3_bucket.call_recordings.arn,
      "${aws_s3_bucket.call_recordings.arn}/*"
    ]
  }
   statement {
    sid    = "AllowS3LogDelivery"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:GetBucketAcl",
      "s3:PutBucketAcl",
      "s3:DeleteObject"
    ]

    resources = [
      aws_s3_bucket.call_recordings.arn,
      "${aws_s3_bucket.call_recordings.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["${data.aws_caller_identity.current.account_id}"]
    }
  }
}

data "aws_caller_identity" "current" {}
