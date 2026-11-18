terraform {
  required_version = ">= 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# Random suffix so the bucket name is globally unique
resource "random_id" "suffix" {
  byte_length = 4
}

module "s3_backup" {
  source = "../../modules/s3-backup"

  bucket_name   = "backup-demo-${random_id.suffix.hex}"
  force_destroy = true # demo only, never in production

  tags = {
    Project = "terraform-aws-s3-backup"
  }
}

output "bucket_name" {
  description = "Name of the backup bucket"
  value       = module.s3_backup.bucket_name
}

output "bucket_arn" {
  description = "ARN of the backup bucket"
  value       = module.s3_backup.bucket_arn
}

output "vault_name" {
  description = "Name of the AWS Backup vault"
  value       = module.s3_backup.backup_vault_name
}

output "backup_role_arn" {
  description = "ARN of the IAM role used by AWS Backup"
  value       = module.s3_backup.backup_role_arn
}

output "read_only_policy_arn" {
  description = "ARN of the read-only IAM policy"
  value       = module.s3_backup.read_only_policy_arn
}