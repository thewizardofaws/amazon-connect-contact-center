# SNS Topic for alarms
resource "aws_sns_topic" "alarms" {
  name              = "${var.project_name}-${var.environment}-alarms"
  display_name      = "${var.project_name} ${var.environment} Alarms"
  kms_master_key_id = var.sns_kms_key_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-alarms"
    }
  )
}

# SNS Topic Subscription
resource "aws_sns_topic_subscription" "email" {
  count     = length(var.alarm_email_addresses)
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = var.alarm_email_addresses[count.index]
}

# CloudWatch Alarm: Lambda Function Errors
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  count               = var.lambda_function_name != "" ? 1 : 0
  alarm_name          = "${var.project_name}-${var.environment}-lambda-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.lambda_error_evaluation_periods
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = var.lambda_error_period
  statistic           = "Sum"
  threshold           = var.lambda_error_threshold
  alarm_description   = "This metric monitors Lambda function errors"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = var.lambda_function_name
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-lambda-errors"
    }
  )
}

# CloudWatch Alarm: Lambda Function Duration
resource "aws_cloudwatch_metric_alarm" "lambda_duration" {
  count               = var.lambda_function_name != "" ? 1 : 0
  alarm_name          = "${var.project_name}-${var.environment}-lambda-duration"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.lambda_duration_evaluation_periods
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = var.lambda_duration_period
  statistic           = "Average"
  threshold           = var.lambda_duration_threshold
  alarm_description   = "This metric monitors Lambda function duration"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = var.lambda_function_name
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-lambda-duration"
    }
  )
}

# CloudWatch Alarm: Lambda Function Throttles
resource "aws_cloudwatch_metric_alarm" "lambda_throttles" {
  count               = var.lambda_function_name != "" ? 1 : 0
  alarm_name          = "${var.project_name}-${var.environment}-lambda-throttles"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.lambda_throttle_evaluation_periods
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  period              = var.lambda_throttle_period
  statistic           = "Sum"
  threshold           = var.lambda_throttle_threshold
  alarm_description   = "This metric monitors Lambda function throttles"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = var.lambda_function_name
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-lambda-throttles"
    }
  )
}

# CloudWatch Alarm: Connect Instance Active Calls (if metric available)
resource "aws_cloudwatch_metric_alarm" "connect_active_calls" {
  count               = var.connect_instance_id != "" ? 1 : 0
  alarm_name          = "${var.project_name}-${var.environment}-connect-active-calls"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.connect_evaluation_periods
  metric_name         = "ActiveCalls"
  namespace           = "AWS/Connect"
  period              = var.connect_period
  statistic           = "Sum"
  threshold           = var.connect_active_calls_threshold
  alarm_description   = "This metric monitors active calls in Connect instance"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = var.connect_instance_id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-connect-active-calls"
    }
  )
}

# CloudWatch Alarm: S3 Bucket Size
resource "aws_cloudwatch_metric_alarm" "s3_bucket_size" {
  count               = var.s3_bucket_name != "" ? 1 : 0
  alarm_name          = "${var.project_name}-${var.environment}-s3-bucket-size"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.s3_evaluation_periods
  metric_name         = "BucketSizeBytes"
  namespace           = "AWS/S3"
  period              = var.s3_period
  statistic           = "Average"
  threshold           = var.s3_bucket_size_threshold
  alarm_description   = "This metric monitors S3 bucket size"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    BucketName = var.s3_bucket_name
    StorageType = "StandardStorage"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-s3-bucket-size"
    }
  )
}
