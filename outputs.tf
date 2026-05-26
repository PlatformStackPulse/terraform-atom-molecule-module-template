output "bucket_id" {
  description = "The ID of the S3 bucket."
  value       = try(aws_s3_bucket.this[0].id, null)
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = try(aws_s3_bucket.this[0].arn, null)
}

output "bucket_domain_name" {
  description = "The bucket domain name."
  value       = try(aws_s3_bucket.this[0].bucket_domain_name, null)
}

output "enabled" {
  description = "Whether the module is enabled."
  value       = var.enabled
}
