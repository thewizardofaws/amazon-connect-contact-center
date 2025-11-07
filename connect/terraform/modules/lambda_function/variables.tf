variable "function_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "description" {
  type        = string
  description = "Description of the Lambda function"
  default     = ""
}

variable "handler" {
  type        = string
  description = "Lambda function handler"
  default     = "main.lambda_handler"
}

variable "runtime" {
  type        = string
  description = "Lambda runtime"
  default     = "python3.11"
}

variable "timeout" {
  type        = number
  description = "Lambda function timeout in seconds"
  default     = 300
}

variable "memory_size" {
  type        = number
  description = "Lambda function memory size in MB"
  default     = 512
}

variable "source_path" {
  type        = string
  description = "Path to the Lambda function source code"
}

variable "s3_bucket_id" {
  type        = string
  description = "S3 bucket ID to trigger Lambda on object creation"
}

variable "s3_bucket_arn" {
  type        = string
  description = "S3 bucket ARN for Lambda permissions"
}

variable "environment_variables" {
  type        = map(string)
  description = "Environment variables for the Lambda function"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the Lambda function"
  default     = {}
}

variable "enable_s3_trigger" {
  type        = bool
  description = "Whether to enable S3 event trigger"
  default     = true
}
