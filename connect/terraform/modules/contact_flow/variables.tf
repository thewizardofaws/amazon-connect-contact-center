variable "instance_id" {
  type        = string
  description = "Amazon Connect instance ID"
}

variable "name" {
  type        = string
  description = "Name of the contact flow"
}

variable "description" {
  type        = string
  description = "Description of the contact flow"
  default     = ""
}

variable "content" {
  type        = string
  description = "JSON content of the contact flow"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the contact flow"
  default     = {}
}
