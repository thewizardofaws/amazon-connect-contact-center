terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

module "connect_instance" {
  source = "./modules/connect_instance"

  aws_region            = var.aws_region
  connect_instance_alias = var.connect_instance_alias
}

module "s3_bucket" {
  source = "./modules/s3_bucket"
  bucket_name           = var.s3_bucket_name
  environment           = var.environment
  connect_instance_name = var.connect_instance_name
}

module "connect_role" {
  source = "./modules/iam_role"
  role_name     = "${var.connect_instance_name}-connect-role"
  service       = "connect.amazonaws.com"
  actions       = ["sts:AssumeRole"]
  s3_bucket_arn = module.s3_bucket.bucket_arn
  environment   = var.environment
}

# Contact Flow Module
module "inbound_contact_flow" {
  source = "./modules/contact_flow"
  
  instance_id  = module.connect_instance.connect_instance_id
  name         = "Inbound Contact Flow"
  description  = "Default inbound contact flow for handling customer calls"
  content      = file("${path.module}/../contact_flows/inbound_flow.json")
  
  tags = {
    Environment = var.environment
    Name        = "Inbound Contact Flow"
  }
}

# Queue Module
module "main_queue" {
  source = "./modules/queue"
  
  instance_id = module.connect_instance.connect_instance_id
  name        = "Main Queue"
  description = "Primary queue for handling customer contacts"
  status      = "ENABLED"
  
  tags = {
    Environment = var.environment
    Name        = "Main Queue"
  }
}

# Lambda Function Module
module "transcribe_sentiment_lambda" {
  source = "./modules/lambda_function"
  
  function_name = "${var.connect_instance_name}-transcribe-sentiment"
  description   = "Lambda function for transcribing call recordings and performing sentiment analysis"
  source_path   = "${path.module}/../../lambda/transcribe_sentiment"
  handler       = "main.lambda_handler"
  runtime       = "python3.11"
  timeout       = 300
  memory_size   = 512
  
  s3_bucket_id  = module.s3_bucket.bucket_id
  s3_bucket_arn = module.s3_bucket.bucket_arn
  
  environment_variables = {
    MEDIA_FORMAT            = "mp3"
    LANGUAGE_CODE           = "en-US"
    COMPREHEND_LANGUAGE_CODE = "en"
    DYNAMODB_TABLE_NAME     = "${var.connect_instance_name}-transcriptions"
    RESULTS_S3_BUCKET       = module.s3_bucket.bucket_id
    TRANSCRIPTION_POLL_INTERVAL = "5"
    MAX_TRANSCRIPTION_WAIT_TIME = "300"
  }
  
  enable_s3_trigger = true
  
  tags = {
    Environment = var.environment
    Name        = "Transcribe Sentiment Lambda"
  }
}
