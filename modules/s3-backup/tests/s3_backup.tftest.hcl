mock_provider "aws" {}

variables {
  bucket_name = "test-bucket"
}

run "versioning_is_enabled" {
  command = plan

  assert {
    condition     = aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Enabled"
    error_message = "Versioning must be enabled, otherwise AWS Backup cannot back up the bucket."
  }
}

run "public_access_is_blocked" {
  command = plan

  assert {
    condition = alltrue([
      aws_s3_bucket_public_access_block.this.block_public_acls,
      aws_s3_bucket_public_access_block.this.block_public_policy,
      aws_s3_bucket_public_access_block.this.ignore_public_acls,
      aws_s3_bucket_public_access_block.this.restrict_public_buckets,
    ])
    error_message = "Public access must be fully blocked."
  }
}

run "retention_uses_variable" {
  command = plan

  variables {
    backup_retention_days = 7
  }

  assert {
    condition     = one(aws_backup_plan.this.rule).lifecycle[0].delete_after == 7
    error_message = "Backup plan retention does not match the variable."
  }
}

run "rejects_zero_retention" {
  command = plan

  variables {
    backup_retention_days = 0
  }

  expect_failures = [var.backup_retention_days]
}