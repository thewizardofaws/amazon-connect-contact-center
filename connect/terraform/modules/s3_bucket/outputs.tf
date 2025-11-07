output "bucket_id" {
  value       = aws_s3_bucket.call_recordings.id
  description = "Name (id) of the S3 bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.call_recordings.arn
  description = "ARN of the S3 bucket"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.call_recordings.bucket_domain_name
  description = "Domain name of the S3 bucket"
}
