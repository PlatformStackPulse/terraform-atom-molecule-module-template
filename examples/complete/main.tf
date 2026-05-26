# Complete Example
#
# This example demonstrates full usage of the module
# with all optional features enabled.

module "example" {
  source = "../.."

  name        = var.name
  environment = var.environment
  namespace   = var.namespace

  versioning_enabled = var.versioning_enabled
  force_destroy      = var.force_destroy
  kms_key_arn        = var.kms_key_arn

  tags = var.tags
}
