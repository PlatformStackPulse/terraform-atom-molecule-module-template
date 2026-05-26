plugin "terraform" {
  enabled = true
  preset  = "all"
}

# Atom pattern: context.tf provides tf-label variables instead of declaring them
# in variables.tf. This is intentional — disable the standard module structure check.
rule "terraform_standard_module_structure" {
  enabled = false
}

plugin "aws" {
  enabled = true
  version = "0.37.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
