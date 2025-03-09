output "connect_instance_arn" {
  value       = module.connect_instance.connect_instance_arn
  description = "ARN of the Amazon Connect instance"
}

output "connect_instance_id" {
  value       = module.connect_instance.connect_instance_id
  description = "ID of the Amazon Connect instance"
}
