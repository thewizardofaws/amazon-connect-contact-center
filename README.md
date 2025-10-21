# Amazon Connect Contact Center Infrastructure as Code

[![AWS](https://img.shields.io/badge/AWS-Amazon%20Connect-orange?style=flat-square)](https://aws.amazon.com/connect/)
[![Infrastructure as Code](https://img.shields.io/badge/Infrastructure%20as%20Code-Terraform-blue?style=flat-square)](https://www.terraform.io/)
[![License: MIT-0](https://img.shields.io/badge/License-MIT--0-brightgreen.svg)](LICENSE)

Terraform modules for deploying and managing Amazon Connect contact center infrastructure. Enables consistent, repeatable deployments with version-controlled infrastructure.

## Overview

[Amazon Connect](https://aws.amazon.com/connect/) is a cloud-based omnichannel contact center service. This repository provides reusable Terraform modules for:

* Connect instances
* Contact flows
* Queues
* IAM roles
* Lambda functions (e.g., transcription and sentiment analysis)
* S3 buckets for storage

## Quick Start

1. **Prerequisites**: AWS CLI configured with appropriate credentials and Terraform installed
2. **Clone**: `git clone <repository-url>`
3. **Configure**: Customize variables in `connect/terraform/variables.tf`
4. **Deploy**: Navigate to `connect/terraform/` and run `terraform init && terraform apply`

## Repository Structure

```
├── connect/terraform/          # Terraform root module
│   ├── modules/                # Reusable Terraform modules
│   │   ├── connect_instance/   # Amazon Connect instance
│   │   ├── contact_flow/       # Contact flow definitions
│   │   ├── queue/              # Contact queues
│   │   ├── iam_role/           # IAM roles and policies
│   │   ├── lambda_function/    # Lambda functions
│   │   └── s3_bucket/          # S3 bucket resources
│   └── main.tf                 # Root module configuration
├── lambda/                     # Lambda function source code
│   └── transcribe_sentiment/   # Transcription and sentiment analysis
└── scripts/                    # Deployment scripts
```

## Contributing

See [CONTRIBUTIONS.md](CONTRIBUTIONS.md) for guidelines.

## Security

See [CONTRIBUTIONS.md#security-issue-notifications](CONTRIBUTIONS.md#security-issue-notifications) for reporting security issues.

## Resources

* [AWS AMER Resources - Re:Invent Your Contact Center with Amazon Connect](https://amer.resources.awscloud.com/contact-center/maximizing-amazon-connect-cl-evaluation-technical)
* [AWS GitHub Repos for Amazon Connect](https://github.com/amazon-connect)

## License

MIT-0 License. See [LICENSE](LICENSE).
