variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, staging, prod)"
  default     = "dev"
}

variable "connect_instance_name" {
  type        = string
  description = "Name of the Connect instance (for IAM role reference)"
  default     = ""
}
