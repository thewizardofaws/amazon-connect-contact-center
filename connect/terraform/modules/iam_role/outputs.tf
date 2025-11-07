output "role_arn" {
  value       = aws_iam_role.connect_role.arn
  description = "ARN of the IAM role"
}

output "role_name" {
  value       = aws_iam_role.connect_role.name
  description = "Name of the IAM role"
}

output "policy_arn" {
  value       = aws_iam_policy.connect_s3_policy.arn
  description = "ARN of the IAM policy"
}
