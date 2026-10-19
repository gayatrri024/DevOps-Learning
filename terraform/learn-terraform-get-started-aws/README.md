# Terraform AWS Learning Projects

This directory contains hands-on Terraform configuration for AWS.

## Project areas

- `aws-ec2/` — EC2 resources and outputs
- `aws-s3/` — S3 resource practice
- `aws-vpc/` — VPC configuration
- `aws-vpc-ec2-nginx/` — networking and EC2 configuration
- `aws-learning-safety/` — learning and safety-related configuration
- `tf-backend/` — Terraform backend practice
- `Simple-HTML-CSS-Portfolio/` — portfolio deployment practice

## Suggested workflow

```bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan
```

Review the plan before applying changes. AWS resources may incur charges.

## State and credentials

Never commit Terraform state files, plans, credentials, `.env` files,
or real `.tfvars` files. Keep sensitive values out of version control.
Destroy test resources when they are no longer needed.
