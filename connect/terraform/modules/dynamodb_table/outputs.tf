output "table_name" {
  value       = aws_dynamodb_table.table.name
  description = "Name of the DynamoDB table"
}

output "table_arn" {
  value       = aws_dynamodb_table.table.arn
  description = "ARN of the DynamoDB table"
}

output "table_id" {
  value       = aws_dynamodb_table.table.id
  description = "ID of the DynamoDB table"
}
