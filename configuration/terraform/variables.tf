variable "aws_region" {
  type    = string
  default = "us-east-1" # Change this to your preferred region
  description = "AWS region"
}

variable "connect_instance_alias" {
  type    = string
  default = "thewizardofaws-connect"
  description = "Amazon Connect instance alias"
}
