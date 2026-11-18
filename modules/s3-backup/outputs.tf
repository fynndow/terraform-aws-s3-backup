output "bucket_name" {
  description = "Name of the backup bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the backup bucket, use it in IAM policies or to start backup jobs"
  value       = aws_s3_bucket.this.arn
}

output "backup_vault_name" {
  description = "Name of the AWS Backup vault that stores the recovery points"
  value       = aws_backup_vault.this.name
}

output "backup_role_arn" {
  description = "ARN of the IAM role AWS Backup uses to back up and restore the bucket"
  value       = aws_iam_role.backup.arn
}

output "read_only_policy_arn" {
  description = "ARN of the read-only IAM policy, attach it to users or groups that need access to the bucket"
  value       = aws_iam_policy.read_only.arn
}