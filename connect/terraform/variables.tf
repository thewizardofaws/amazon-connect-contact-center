variable "aws_region" {
  type    = string
  default = "us-east-1" # Change this to your preferred region
  description = "AWS region"
}

variable "connect_instance_alias" {
  type    = string
  default = "thewizardofaws-connect"
  description = "Amazon Connect instance alias"
}

variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket for call recordings"
  default     = "your-connect-instance-recordings"
}

variable "environment" {
  type        = string
  description = "The environment (e.g., dev, staging, prod)"
  default     = "dev"
}

variable "connect_instance_name" {
  type        = string
  description = "The name of the Amazon Connect instance"
}
