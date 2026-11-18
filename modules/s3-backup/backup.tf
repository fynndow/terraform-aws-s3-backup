locals {
  backup_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup",
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores",
    "arn:aws:iam::aws:policy/AWSBackupServiceRolePolicyForS3Backup",
    "arn:aws:iam::aws:policy/AWSBackupServiceRolePolicyForS3Restore",
  ]
}

resource "aws_iam_role" "backup" {
  name = "${var.bucket_name}-backup"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "backup.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "backup" {
  for_each   = toset(local.backup_policies)
  role       = aws_iam_role.backup.name
  policy_arn = each.value
}

resource "aws_backup_vault" "this" {
  name          = "${var.bucket_name}-vault"
  force_destroy = var.force_destroy
  tags          = var.tags
}

resource "aws_backup_plan" "this" {
  name = "${var.bucket_name}-plan"

  rule {
    rule_name         = "daily"
    target_vault_name = aws_backup_vault.this.name
    schedule          = var.backup_schedule

    lifecycle {
      delete_after = var.backup_retention_days
    }
  }
  tags = var.tags
}

resource "aws_backup_selection" "this" {
  name         = "s3-bucket"
  iam_role_arn = aws_iam_role.backup.arn
  plan_id      = aws_backup_plan.this.id
  resources    = [aws_s3_bucket.this.arn]
}