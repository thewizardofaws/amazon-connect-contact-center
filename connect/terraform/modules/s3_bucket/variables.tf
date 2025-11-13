variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket for storing call recordings. Must be globally unique across all AWS accounts, 3-63 characters, lowercase alphanumeric with dots and hyphens. Cannot start or end with a dot or hyphen. Used for storing Amazon Connect call recordings and transcriptions."
}

variable "environment" {
  type        = string
  description = "Environment name used for tagging and resource identification. Must be one of: dev, staging, prod. Used for resource tagging and environment-specific configurations."
  default     = "dev"
}

variable "connect_instance_name" {
  type        = string
  description = "Name of the Amazon Connect instance used for IAM role reference in bucket policies. Used to grant Connect instance access to the S3 bucket for storing and retrieving call recordings. Leave empty if IAM role reference is not needed."
  default     = ""
}
