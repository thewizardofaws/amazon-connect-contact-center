output "lambda_function_arn" {
  value       = aws_lambda_function.function.arn
  description = "ARN of the Lambda function"
}

output "lambda_function_name" {
  value       = aws_lambda_function.function.function_name
  description = "Name of the Lambda function"
}

output "lambda_role_arn" {
  value       = aws_iam_role.lambda_role.arn
  description = "ARN of the IAM role for the Lambda function"
}
