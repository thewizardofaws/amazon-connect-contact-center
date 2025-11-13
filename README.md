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

### Security Hardening

This infrastructure implements several security best practices:

#### IAM Security
- **Least Privilege**: IAM roles and policies follow the principle of least privilege, granting only necessary permissions
- **Service-Specific Roles**: Separate IAM roles for Connect, Lambda, and other services
- **Policy Validation**: All IAM policies are reviewed and validated before deployment

#### Data Protection
- **Encryption at Rest**: S3 buckets use server-side encryption (AES256) by default
- **Encryption in Transit**: All AWS API calls use TLS/SSL
- **S3 Bucket Policies**: Restrictive bucket policies limit access to authorized roles only

#### Network Security
- **Private Access**: Connect instances can be configured for private VPC connectivity
- **No Public Endpoints**: All resources are accessed through secure AWS endpoints

#### Monitoring and Logging
- **CloudWatch Logs**: All Lambda functions log to CloudWatch with 14-day retention
- **CloudWatch Alarms**: Automated monitoring with SNS notifications for critical events
- **Audit Trail**: All infrastructure changes are tracked through Terraform state

#### Best Practices
1. **Secrets Management**: Use AWS Secrets Manager or Parameter Store for sensitive data
2. **Regular Audits**: Review IAM policies and permissions quarterly
3. **Access Control**: Implement MFA for all AWS accounts
4. **Version Pinning**: Terraform providers and modules use version constraints
5. **State Encryption**: Ensure Terraform state files are stored in encrypted S3 buckets with versioning enabled

#### Compliance Considerations
- Ensure compliance with your organization's data retention policies
- Review and adjust S3 lifecycle rules based on regulatory requirements
- Implement data classification and tagging for compliance tracking

## Backup and Recovery

### Backup Strategy

#### Infrastructure State
- **Terraform State**: Stored in versioned S3 bucket (recommended: enable versioning and encryption)
- **State Locking**: Use DynamoDB for state locking to prevent concurrent modifications
- **State Backups**: Regularly backup Terraform state files before major changes

#### Data Backups
- **S3 Bucket Versioning**: Enabled by default for call recordings bucket
- **S3 Lifecycle Policies**: Configured to retain versions and manage storage costs
- **Cross-Region Replication**: Consider enabling for critical recordings (manual configuration)

#### Configuration Backups
- **Contact Flows**: Stored as JSON files in `connect/contact_flows/` directory
- **Terraform Configurations**: All infrastructure code is version-controlled in Git
- **Variable Files**: Environment-specific configurations stored in `.tfvars` files

### Recovery Procedures

#### Infrastructure Recovery
1. **Full Infrastructure Restore**:
   ```bash
   terraform init
   terraform plan -var-file=<environment>.tfvars
   terraform apply -var-file=<environment>.tfvars
   ```

2. **State File Recovery**:
   - Restore from S3 versioning if state file is corrupted
   - Import existing resources if state is lost:
     ```bash
     terraform import <resource_type>.<name> <resource_id>
     ```

#### Data Recovery
1. **S3 Object Recovery**:
   - Use S3 versioning to restore previous versions
   - Use S3 cross-region replication if enabled
   - Restore from backups if automated backups are configured

2. **DynamoDB Recovery**:
   - Use point-in-time recovery (PITR) if enabled
   - Restore from DynamoDB backups

#### Disaster Recovery Planning
1. **RTO/RPO Objectives**: Define Recovery Time Objective (RTO) and Recovery Point Objective (RPO)
2. **Multi-Region Setup**: Consider deploying to multiple AWS regions for high availability
3. **Documentation**: Maintain runbooks for common recovery scenarios
4. **Testing**: Regularly test backup and recovery procedures

#### Backup Verification
- **Monthly Checks**: Verify Terraform state backups
- **Quarterly Tests**: Perform full infrastructure recovery tests
- **Monitoring**: Set up CloudWatch alarms for backup failures

### Recovery Contacts
- **Infrastructure Team**: [Your team contact]
- **AWS Support**: Escalate critical issues through AWS Support
- **On-Call Rotation**: Ensure 24/7 coverage for production environments

## Resources

* [AWS AMER Resources - Re:Invent Your Contact Center with Amazon Connect](https://amer.resources.awscloud.com/contact-center/maximizing-amazon-connect-cl-evaluation-technical)
* [AWS GitHub Repos for Amazon Connect](https://github.com/amazon-connect)
* [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* [Amazon Connect Best Practices](https://docs.aws.amazon.com/connect/latest/adminguide/best-practices.html)

## License

MIT-0 License. See [LICENSE](LICENSE).
