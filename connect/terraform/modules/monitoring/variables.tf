variable "project_name" {
  type        = string
  description = "Project name used for resource naming (e.g., 'connect-center')"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, staging, prod)"
}

variable "alarm_email_addresses" {
  type        = list(string)
  description = "List of email addresses to receive alarm notifications"
  default     = []
}

variable "sns_kms_key_id" {
  type        = string
  description = "KMS key ID for SNS topic encryption (optional, uses default AWS managed key if not provided)"
  default     = ""
}

# Lambda Monitoring Variables
variable "lambda_function_name" {
  type        = string
  description = "Name of the Lambda function to monitor (leave empty to disable Lambda monitoring)"
  default     = ""
}

variable "lambda_error_threshold" {
  type        = number
  description = "Number of errors before triggering alarm"
  default     = 5
}

variable "lambda_error_period" {
  type        = number
  description = "Period in seconds for Lambda error metric evaluation"
  default     = 300
}

variable "lambda_error_evaluation_periods" {
  type        = number
  description = "Number of periods Lambda error metric must exceed threshold"
  default     = 2
}

variable "lambda_duration_threshold" {
  type        = number
  description = "Lambda duration threshold in milliseconds before triggering alarm"
  default     = 5000
}

variable "lambda_duration_period" {
  type        = number
  description = "Period in seconds for Lambda duration metric evaluation"
  default     = 300
}

variable "lambda_duration_evaluation_periods" {
  type        = number
  description = "Number of periods Lambda duration metric must exceed threshold"
  default     = 2
}

variable "lambda_throttle_threshold" {
  type        = number
  description = "Number of throttles before triggering alarm"
  default     = 3
}

variable "lambda_throttle_period" {
  type        = number
  description = "Period in seconds for Lambda throttle metric evaluation"
  default     = 300
}

variable "lambda_throttle_evaluation_periods" {
  type        = number
  description = "Number of periods Lambda throttle metric must exceed threshold"
  default     = 1
}

# Connect Monitoring Variables
variable "connect_instance_id" {
  type        = string
  description = "Amazon Connect instance ID to monitor (leave empty to disable Connect monitoring)"
  default     = ""
}

variable "connect_active_calls_threshold" {
  type        = number
  description = "Number of active calls before triggering alarm"
  default     = 1000
}

variable "connect_period" {
  type        = number
  description = "Period in seconds for Connect metric evaluation"
  default     = 300
}

variable "connect_evaluation_periods" {
  type        = number
  description = "Number of periods Connect metric must exceed threshold"
  default     = 2
}

# S3 Monitoring Variables
variable "s3_bucket_name" {
  type        = string
  description = "S3 bucket name to monitor (leave empty to disable S3 monitoring)"
  default     = ""
}

variable "s3_bucket_size_threshold" {
  type        = number
  description = "S3 bucket size threshold in bytes before triggering alarm (default 100GB)"
  default     = 107374182400
}

variable "s3_period" {
  type        = number
  description = "Period in seconds for S3 metric evaluation"
  default     = 86400
}

variable "s3_evaluation_periods" {
  type        = number
  description = "Number of periods S3 metric must exceed threshold"
  default     = 1
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all monitoring resources"
  default     = {}
}
