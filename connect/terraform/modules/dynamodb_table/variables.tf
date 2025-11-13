variable "table_name" {
  type        = string
  description = "Name of the DynamoDB table"
}

variable "hash_key" {
  type        = string
  description = "Attribute name to use as the hash (partition) key"
}

variable "hash_key_type" {
  type        = string
  description = "Attribute type for the hash key (S for string, N for number, B for binary)"
  default     = "S"
}

variable "range_key" {
  type        = string
  description = "Attribute name to use as the range (sort) key (optional)"
  default     = ""
}

variable "range_key_type" {
  type        = string
  description = "Attribute type for the range key (S for string, N for number, B for binary)"
  default     = "S"
}

variable "billing_mode" {
  type        = string
  description = "Billing mode for the table (PROVISIONED or PAY_PER_REQUEST)"
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  type        = number
  description = "Number of read units for PROVISIONED billing mode"
  default     = 5
}

variable "write_capacity" {
  type        = number
  description = "Number of write units for PROVISIONED billing mode"
  default     = 5
}

variable "point_in_time_recovery" {
  type        = bool
  description = "Enable point-in-time recovery"
  default     = true
}

variable "kms_key_id" {
  type        = string
  description = "ARN of the KMS key for encryption (optional, uses AWS managed key if not provided)"
  default     = ""
}

variable "global_secondary_indexes" {
  type = list(object({
    name            = string
    hash_key        = string
    range_key       = optional(string)
    projection_type = string
    read_capacity   = optional(number)
    write_capacity  = optional(number)
  }))
  description = "List of global secondary indexes to create"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the DynamoDB table"
  default     = {}
}
