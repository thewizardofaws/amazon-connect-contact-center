variable "role_name" {
  type        = string
  description = "Name of the IAM role"
}

variable "service" {
  type        = string
  description = "AWS service that will assume this role"
  default     = "connect.amazonaws.com"
}

variable "actions" {
  type        = list(string)
  description = "List of actions for the assume role policy"
  default     = ["sts:AssumeRole"]
}

variable "s3_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket for storing call recordings"
  default     = ""
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, staging, prod)"
  default     = "dev"
}
