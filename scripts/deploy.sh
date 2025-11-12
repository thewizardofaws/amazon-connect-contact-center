#!/bin/bash

# Deployment script for Amazon Connect infrastructure
# Usage: ./scripts/deploy.sh [environment]
# Example: ./scripts/deploy.sh dev

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default environment
ENVIRONMENT=${1:-dev}

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    echo -e "${RED}Error: Invalid environment '$ENVIRONMENT'. Must be one of: dev, staging, prod${NC}"
    exit 1
fi

# Set paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TERRAFORM_DIR="$PROJECT_ROOT/connect/terraform"
TFVARS_FILE="$TERRAFORM_DIR/${ENVIRONMENT}.tfvars"

# Check if tfvars file exists
if [ ! -f "$TFVARS_FILE" ]; then
    echo -e "${RED}Error: Configuration file not found: $TFVARS_FILE${NC}"
    echo -e "${YELLOW}Please ensure the ${ENVIRONMENT}.tfvars file exists.${NC}"
    exit 1
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deploying to: ${ENVIRONMENT} environment${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Change to terraform directory
cd "$TERRAFORM_DIR"

# Step 1: Terraform Init
echo -e "${YELLOW}Step 1: Initializing Terraform...${NC}"
terraform init
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Terraform init failed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Terraform initialized successfully${NC}"
echo ""

# Step 2: Terraform Format Check
echo -e "${YELLOW}Step 2: Checking Terraform formatting...${NC}"
terraform fmt -check -recursive
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Warning: Some Terraform files are not properly formatted${NC}"
    echo -e "${YELLOW}Run 'terraform fmt -recursive' to fix formatting issues${NC}"
fi
echo ""

# Step 3: Terraform Validate
echo -e "${YELLOW}Step 3: Validating Terraform configuration...${NC}"
terraform validate
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Terraform validation failed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Terraform configuration is valid${NC}"
echo ""

# Step 4: Terraform Plan
echo -e "${YELLOW}Step 4: Running Terraform plan...${NC}"
terraform plan -var-file="$TFVARS_FILE" -out=tfplan
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Terraform plan failed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Terraform plan completed successfully${NC}"
echo ""

# Step 5: Confirm before apply
if [ "$ENVIRONMENT" == "prod" ]; then
    echo -e "${RED}WARNING: You are about to deploy to PRODUCTION environment!${NC}"
    read -p "Are you sure you want to continue? (yes/no): " -r
    echo
    if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        echo -e "${YELLOW}Deployment cancelled${NC}"
        exit 0
    fi
fi

# Step 6: Terraform Apply
echo -e "${YELLOW}Step 5: Applying Terraform configuration...${NC}"
terraform apply tfplan
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Terraform apply failed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Terraform apply completed successfully${NC}"
echo ""

# Cleanup plan file
rm -f tfplan

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${GREEN}Environment: ${ENVIRONMENT}${NC}"
echo -e "${GREEN}========================================${NC}"
