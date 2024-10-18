<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.16 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.16 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.ecr_repository_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.ecr_repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [null_resource.aws_caller_identity](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.ecr_upload_initial_image](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.pwd_and_whoami](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | environment name | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | prefix | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | product name | `string` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | profile | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_caller_identity"></a> [aws\_caller\_identity](#output\_aws\_caller\_identity) | n/a |
<!-- END_TF_DOCS -->