<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.16 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.16 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.SSM_PROFILE](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.S3_POLICY](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.SSM_ROLE](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aws_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | environment name | `string` | n/a | yes |
| <a name="input_iam_policy_list"></a> [iam\_policy\_list](#input\_iam\_policy\_list) | IAM Policy to be attached to role | `list(any)` | <pre>[<br>  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",<br>  "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"<br>]</pre> | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | prefix | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | product name | `string` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | profile | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->