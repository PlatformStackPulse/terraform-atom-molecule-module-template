# Terraform Module Template

[![CI](https://github.com/PlatformStackPulse/Terraform-module-base-template/actions/workflows/ci.yml/badge.svg)](https://github.com/PlatformStackPulse/Terraform-module-base-template/actions/workflows/ci.yml)
[![Release](https://github.com/PlatformStackPulse/Terraform-module-base-template/actions/workflows/release.yml/badge.svg)](https://github.com/PlatformStackPulse/Terraform-module-base-template/actions/workflows/release.yml)

A production-ready template for creating Terraform modules following the **one module per repository** best practice, with built-in CI/CD, security scanning, testing, documentation generation, and publishing to public registries.

## Features

- **One Module Per Repo** — Module lives at the root; no nested `modules/` directory
- **Registry Publishing** — Auto-publish to Terraform Registry, Artifactory, or GitLab on release
- **Native Terraform Testing** — `terraform test` with mock providers (no external tools)
- **Security Scanning** — Trivy IaC scanning for HIGH/CRITICAL vulnerabilities
- **Linting** — TFLint with AWS ruleset (preset "all")
- **Auto Documentation** — terraform-docs generates README sections on every commit
- **GitHub Actions CI/CD** — Workflows for the full module lifecycle
- **Pre-Commit Hooks** — Format, validate, lint, docs, and security on every commit
- **Conventional Commits** — Enforced commit message format
- **Semantic Versioning** — Automated version management and releases
- **DevContainer** — VS Code remote development ready

## Quick Start

### Create a New Module

```bash
# Create repo from template (name MUST follow: terraform-<PROVIDER>-<NAME>)
gh repo create PlatformStackPulse/terraform-aws-my-module --template PlatformStackPulse/Terraform-module-base-template --public

# Clone
git clone git@github.com:PlatformStackPulse/terraform-aws-my-module.git
cd terraform-aws-my-module

# Install tools and hooks
make dev-setup
make hooks

# Run all checks
make all
```

### Customise the Template

1. Replace the example S3 resources in `main.tf` with your actual resources
2. Update `variables.tf`, `outputs.tf`, and `versions.tf`
3. Write tests in `tests/unit/main_test.tftest.hcl`
4. Update `examples/complete/` with real usage
5. Update `.github/CODEOWNERS`
6. Update this `README.md`

See [TEMPLATE_GUIDE.md](TEMPLATE_GUIDE.md) for detailed instructions.

## Usage

### From GitHub

```hcl
module "this" {
  source = "github.com/PlatformStackPulse/terraform-aws-my-module?ref=v1.0.0"

  name        = "my-resource"
  environment = "dev"
  namespace   = "myorg"

  tags = {
    Project = "example"
    Owner   = "platform-engineering"
  }
}
```

### From Terraform Registry

```hcl
module "this" {
  source  = "PlatformStackPulse/my-module/aws"
  version = "~> 1.0"

  name        = "my-resource"
  environment = "dev"
  namespace   = "myorg"

  tags = {
    Project = "example"
    Owner   = "platform-engineering"
  }
}
```

## Module Structure

```
├── main.tf           # Primary resource definitions
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── versions.tf       # Terraform and provider version constraints
├── locals.tf         # Local values and naming conventions
├── data.tf           # Data sources
├── examples/         # Usage examples for consumers
│   └── complete/     # Full-featured example
├── tests/            # Terraform native tests
│   ├── unit/         # Unit tests with mock providers
│   └── integration/  # Integration tests (real AWS)
├── .github/          # GitHub Actions + templates
├── scripts/          # Automation scripts
└── Makefile          # Build automation
```

## Make Targets

```
make help              Show all targets
make init              Initialize the module
make fmt               Format all Terraform files
make fmt-check         Check formatting (CI mode)
make validate          Validate the module
make lint              Run TFLint
make test              Run all tests
make test-unit         Run unit tests only
make test-integration  Run integration tests
make security          Run Trivy security scan
make docs              Generate terraform-docs
make clean             Remove .terraform dirs
make all               Run all checks
make dev-setup         Install development tools
make hooks             Install pre-commit hooks
make changelog         Regenerate CHANGELOG.md
make version           Show current version
make release           Create version tag (BUMP=patch|minor|major)
```

## Publishing

### Terraform Registry (Public)

The [Terraform Registry](https://registry.terraform.io) automatically publishes new versions when you create a GitHub Release:

1. **Name your repo** following the convention: `terraform-<PROVIDER>-<NAME>` (e.g., `terraform-aws-vpc`)
2. **Connect** at [registry.terraform.io/github/create](https://registry.terraform.io/github/create)
3. **Tag and release** — every semver tag (`v1.0.0`) is auto-published

### Terraform Cloud / Enterprise (Private)

1. Connect your VCS provider in TFC/TFE settings
2. Create a Module in the private registry pointing to this repo
3. Semver tags trigger automatic version publication

### JFrog Artifactory

Set these repository variables/secrets in GitHub:
- `ARTIFACTORY_ENABLED` = `true` (variable)
- `ARTIFACTORY_URL` — e.g., `https://myorg.jfrog.io/artifactory` (variable)
- `ARTIFACTORY_REPO` — e.g., `terraform-modules` (variable)
- `ARTIFACTORY_TOKEN` (secret)

### GitLab Terraform Registry

Uncomment the `publish-gitlab` job in `.github/workflows/release.yml` and set:
- `GITLAB_TOKEN` (secret)
- `GITLAB_PROJECT_ID` (variable)

## CI/CD Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `ci.yml` | Push/PR to main | Format, validate, lint, test, security |
| `release.yml` | Tag v*.*.* | Create GitHub Release + publish to registries |
| `codeql.yml` | Weekly + push main | SAST security analysis |
| `dependencies.yml` | Weekly | Check for provider updates |
| `changelog.yml` | Push main | Auto-update CHANGELOG.md |
| `version-bump.yml` | Manual | Bump patch/minor/major version |

## Pre-Commit Hooks

Installed via `make hooks`. Runs on every commit:

- `terraform_fmt` — Format check
- `terraform_validate` — Syntax validation
- `terraform_tflint` — Linting with AWS rules
- `terraform_docs` — Auto-generate documentation
- `terraform_trivy` — Security scanning (HIGH/CRITICAL)
- `gitlint` — Conventional commit message validation

## Module Documentation

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., dev, staging, prod). | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource. Used in naming convention. | `string` | n/a | yes |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources. | `bool` | `true` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow destruction of non-empty S3 bucket. | `bool` | `false` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of the KMS key for server-side encryption. If null, AES256 is used. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for resource naming (e.g., org name, team). | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to all resources. | `map(string)` | `{}` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Enable S3 bucket versioning. | `bool` | `true` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the S3 bucket. |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | The bucket domain name. |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The ID of the S3 bucket. |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | Whether the module is enabled. |
<!-- END_TF_DOCS -->

## Learning Materials

| Document | Description |
|----------|-------------|
| [docs/TERRAFORM_FLAGS.md](docs/TERRAFORM_FLAGS.md) | Terraform CLI flags reference (`-refresh`, `-upgrade`, etc.) |
| [docs/TFENV.md](docs/TFENV.md) | tfenv version manager guide |
| [docs/MAKEFILE_ENV.md](docs/MAKEFILE_ENV.md) | Makefile targets and `.env` configuration |
| [TEMPLATE_GUIDE.md](TEMPLATE_GUIDE.md) | Step-by-step guide to customise this template |
| [WORKFLOW.md](WORKFLOW.md) | Branching strategy and CI/CD pipeline |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Development workflow and guidelines |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development workflow and guidelines.

## Security

See [SECURITY.md](SECURITY.md) for vulnerability reporting.

## License

[MIT](LICENSE)
