variable "aws_region" {
  type        = string
  description = "AWS region where the Connect instance will be deployed. Must be a valid AWS region identifier (e.g., us-east-1, eu-west-1). Amazon Connect is available in specific regions only."
}

variable "connect_instance_alias" {
  type        = string
  description = "Amazon Connect instance alias (unique identifier). Must be lowercase alphanumeric with hyphens, 1-62 characters, and cannot start or end with a hyphen. This alias must be unique across all Connect instances in your AWS account."
}
