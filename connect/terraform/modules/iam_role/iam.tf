# IAM role for Amazon Connect to assume
resource "aws_iam_role" "connect_role" {
  name = "${var.connect_instance_name}-connect-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "connect.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })

  tags = {
    Name        = "${var.connect_instance_name}-connect-role"
    Environment = "${var.environment}"
  }
}

# IAM policy for Amazon Connect to write to S3
resource "aws_iam_policy" "connect_s3_policy" {
  name        = "${var.connect_instance_name}-connect-s3-policy"
  description = "IAM policy for Amazon Connect to write to S3 bucket"
  policy      = data.aws_iam_policy_document.connect_s3_policy_document.json
}

data "aws_iam_policy_document" "connect_s3_policy_document" {
  statement {
    sid    = "AllowS3Write"
    effect = "Allow"
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
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "connect_s3_policy_attachment" {
  role       = aws_iam_role.connect_role.name
  policy_arn = aws_iam_policy.connect_s3_policy.arn
}