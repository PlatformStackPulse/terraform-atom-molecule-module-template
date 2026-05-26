# Unit Tests for Example Module
#
# These tests use mock providers — no real AWS calls are made.
# Run with: terraform test
# Run verbose: terraform test -verbose
# Run specific: terraform test -run "test_name"

mock_provider "aws" {}

# ---------------------------------------------------------------------------
# Test: Module creates resources with valid inputs
# ---------------------------------------------------------------------------
variables {
  name        = "test-bucket"
  environment = "dev"
  namespace   = "unit"
  enabled     = true
}

run "creates_s3_bucket" {
  command = plan

  assert {
    condition     = length(aws_s3_bucket.this) == 1
    error_message = "Expected one S3 bucket to be created."
  }

  assert {
    condition     = aws_s3_bucket.this[0].bucket == "unit-dev-test-bucket"
    error_message = "Bucket name should follow naming convention: {namespace}-{environment}-{name}."
  }

  assert {
    condition     = aws_s3_bucket.this[0].tags["Environment"] == "dev"
    error_message = "Bucket should have Environment tag set to 'dev'."
  }

  assert {
    condition     = aws_s3_bucket.this[0].tags["ManagedBy"] == "terraform"
    error_message = "Bucket should have ManagedBy tag set to 'terraform'."
  }
}

# ---------------------------------------------------------------------------
# Test: Module creates versioning configuration
# ---------------------------------------------------------------------------
run "enables_versioning" {
  command = plan

  variables {
    versioning_enabled = true
  }

  assert {
    condition     = aws_s3_bucket_versioning.this[0].versioning_configuration[0].status == "Enabled"
    error_message = "Versioning should be enabled."
  }
}

run "disables_versioning" {
  command = plan

  variables {
    versioning_enabled = false
  }

  assert {
    condition     = aws_s3_bucket_versioning.this[0].versioning_configuration[0].status == "Suspended"
    error_message = "Versioning should be suspended."
  }
}

# ---------------------------------------------------------------------------
# Test: Module enforces encryption
# ---------------------------------------------------------------------------
run "uses_aes256_by_default" {
  command = plan

  variables {
    kms_key_arn = null
  }

  assert {
    condition     = aws_s3_bucket_server_side_encryption_configuration.this[0].rule[0].apply_server_side_encryption_by_default[0].sse_algorithm == "AES256"
    error_message = "Default encryption should be AES256 when no KMS key is provided."
  }
}

run "uses_kms_when_key_provided" {
  command = plan

  variables {
    kms_key_arn = "arn:aws:kms:eu-west-1:123456789012:key/test-key-id"
  }

  assert {
    condition     = aws_s3_bucket_server_side_encryption_configuration.this[0].rule[0].apply_server_side_encryption_by_default[0].sse_algorithm == "aws:kms"
    error_message = "Encryption should use aws:kms when KMS key is provided."
  }
}

# ---------------------------------------------------------------------------
# Test: Module blocks public access
# ---------------------------------------------------------------------------
run "blocks_public_access" {
  command = plan

  assert {
    condition     = aws_s3_bucket_public_access_block.this[0].block_public_acls == true
    error_message = "Public ACLs should be blocked."
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this[0].block_public_policy == true
    error_message = "Public policies should be blocked."
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this[0].restrict_public_buckets == true
    error_message = "Public buckets should be restricted."
  }
}

# ---------------------------------------------------------------------------
# Test: Module is disabled when enabled = false
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = length(aws_s3_bucket.this) == 0
    error_message = "No resources should be created when module is disabled."
  }

  assert {
    condition     = length(aws_s3_bucket_public_access_block.this) == 0
    error_message = "No public access block should be created when module is disabled."
  }
}

# ---------------------------------------------------------------------------
# Test: Naming without namespace
# ---------------------------------------------------------------------------
run "naming_without_namespace" {
  command = plan

  variables {
    namespace = ""
  }

  assert {
    condition     = aws_s3_bucket.this[0].bucket == "dev-test-bucket"
    error_message = "Without namespace, bucket name should be: {environment}-{name}."
  }
}

# ---------------------------------------------------------------------------
# Test: Variable validation — invalid environment
# ---------------------------------------------------------------------------
run "rejects_invalid_environment" {
  command = plan

  variables {
    environment = "invalid"
  }

  expect_failures = [
    var.environment,
  ]
}

# ---------------------------------------------------------------------------
# Test: Variable validation — empty name
# ---------------------------------------------------------------------------
run "rejects_empty_name" {
  command = plan

  variables {
    name = "   "
  }

  expect_failures = [
    var.name,
  ]
}
