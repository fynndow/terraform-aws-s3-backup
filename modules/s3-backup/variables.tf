variable "bucket_name" {
  description = "Globally unique name of the backup bucket"
  type        = string
}

variable "backup_schedule" {
  description = "AWS Backup schedule (UTC)"
  type        = string
  default     = "cron(0 3 * * ? *)"
}

variable "backup_retention_days" {
  description = "Number of days backups are kept in the vault"
  type        = number
  default     = 35

  validation {
    condition     = var.backup_retention_days >= 1
    error_message = "backup_retention_days must be at least 1."
  }
}

variable "noncurrent_version_days" {
  description = "Days after which noncurrent object versions are deleted"
  type        = number
  default     = 30
}

variable "force_destroy" {
  description = "Delete bucket and vault including all contents on destroy (demo use only)"
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}