output "sns_topic_arn" {
  value       = aws_sns_topic.alarms.arn
  description = "ARN of the SNS topic for alarms"
}

output "sns_topic_name" {
  value       = aws_sns_topic.alarms.name
  description = "Name of the SNS topic for alarms"
}
