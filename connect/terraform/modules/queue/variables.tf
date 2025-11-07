variable "instance_id" {
  type        = string
  description = "Amazon Connect instance ID"
}

variable "name" {
  type        = string
  description = "Name of the queue"
}

variable "description" {
  type        = string
  description = "Description of the queue"
  default     = ""
}

variable "hours_of_operation_id" {
  type        = string
  description = "Hours of operation ID"
  default     = ""
}

variable "max_contacts" {
  type        = number
  description = "Maximum number of contacts in the queue"
  default     = null
}

variable "outbound_caller_config" {
  type = object({
    outbound_caller_id_name     = optional(string)
    outbound_caller_id_number_id = optional(string)
    outbound_flow_id             = optional(string)
  })
  description = "Outbound caller configuration"
  default     = null
}

variable "quick_connect_ids" {
  type        = list(string)
  description = "List of quick connect IDs associated with the queue"
  default     = []
}

variable "status" {
  type        = string
  description = "Status of the queue (ENABLED or DISABLED)"
  default     = "ENABLED"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the queue"
  default     = {}
}
