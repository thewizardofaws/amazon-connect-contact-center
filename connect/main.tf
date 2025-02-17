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

# Other modules will go here (contact flows, queues, etc.)
