output "connect_instance_id" {
  value       = aws_connect_instance.connect_instance.id
  description = "ID of the Amazon Connect instance"
}

output "connect_instance_arn" {
  value       = aws_connect_instance.connect_instance.arn
  description = "ARN of the Amazon Connect instance"
}
