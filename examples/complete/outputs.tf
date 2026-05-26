output "bucket_id" {
  description = "The ID of the S3 bucket."
  value       = module.example.bucket_id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = module.example.bucket_arn
}

output "enabled" {
  description = "Whether the module is enabled."
  value       = module.example.enabled
}
