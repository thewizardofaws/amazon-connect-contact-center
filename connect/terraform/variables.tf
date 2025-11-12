variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region where resources will be deployed"

  validation {
    condition = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$|^[a-z0-9]$", var.aws_region))
    error_message = "AWS region must be a valid AWS region identifier."
  }
}

variable "connect_instance_alias" {
  type        = string
  description = "Amazon Connect instance alias (must be unique and lowercase, 1-62 characters)"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$|^[a-z0-9]$", var.connect_instance_alias)) && length(var.connect_instance_alias) >= 1 && length(var.connect_instance_alias) <= 62
    error_message = "Connect instance alias must be lowercase alphanumeric with hyphens, 1-62 characters, and cannot start or end with a hyphen."
  }
}

variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket for call recordings (must be globally unique)"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$|^[a-z0-9]$", var.s3_bucket_name)) && length(var.s3_bucket_name) >= 3 && length(var.s3_bucket_name) <= 63
    error_message = "S3 bucket name must be 3-63 characters, lowercase alphanumeric with dots and hyphens, and cannot start or end with a dot or hyphen."
  }
}

variable "environment" {
  type        = string
  description = "The environment (e.g., dev, staging, prod)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "connect_instance_name" {
  type        = string
  description = "The name of the Amazon Connect instance (used for resource naming)"

  validation {
    condition     = length(var.connect_instance_name) >= 1 && length(var.connect_instance_name) <= 100 && can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]*[a-zA-Z0-9]$|^[a-zA-Z0-9]$", var.connect_instance_name))
    error_message = "Connect instance name must be 1-100 characters, alphanumeric with hyphens and underscores, and cannot start or end with special characters."
  }
}
