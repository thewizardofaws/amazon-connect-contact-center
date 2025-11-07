output "queue_id" {
  value       = aws_connect_queue.queue.queue_id
  description = "ID of the queue"
}

output "queue_arn" {
  value       = aws_connect_queue.queue.arn
  description = "ARN of the queue"
}
