variable "name" {
  description = "Name of the resource."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "namespace" {
  description = "Namespace for resource naming."
  type        = string
  default     = ""
}

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
  description = "ARN of the KMS key for encryption."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags."
  type        = map(string)
  default     = {}
}
