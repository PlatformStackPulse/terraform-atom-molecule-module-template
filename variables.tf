# -----------------------------------------------------------------------------
# Module-Specific Variables
#
# Note: Standard labeling variables (enabled, namespace, tenant, environment,
# stage, name, delimiter, attributes, tags, label_order, etc.) are provided
# by context.tf via the tf-label module.
# -----------------------------------------------------------------------------

variable "versioning_enabled" {
  description = "Enable S3 bucket versioning."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow destruction of non-empty S3 bucket."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN of the KMS key for server-side encryption. If null, AES256 is used."
  type        = string
  default     = null
}
