locals {
  # Naming convention: {namespace}-{environment}-{name}
  name_prefix = var.namespace != "" ? "${var.namespace}-${var.environment}" : var.environment
  bucket_name = "${local.name_prefix}-${var.name}"

  # Standard tags applied to all resources
  tags = merge(
    {
      "Name"        = local.bucket_name
      "Environment" = var.environment
      "ManagedBy"   = "terraform"
      "Module"      = "example"
    },
    var.tags,
  )
}
