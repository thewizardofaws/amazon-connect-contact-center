output "contact_flow_id" {
  value       = aws_connect_contact_flow.contact_flow.contact_flow_id
  description = "ID of the contact flow"
}

output "contact_flow_arn" {
  value       = aws_connect_contact_flow.contact_flow.arn
  description = "ARN of the contact flow"
}
