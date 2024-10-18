<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.16 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr"></a> [ecr](#module\_ecr) | ./module/ecr | n/a |
| <a name="module_ecs_vpc_endpoint"></a> [ecs\_vpc\_endpoint](#module\_ecs\_vpc\_endpoint) | ./module/ecs_vpc_endpoint | n/a |
| <a name="module_elb"></a> [elb](#module\_elb) | ./module/elb | n/a |
| <a name="module_oidc"></a> [oidc](#module\_oidc) | ./module/oidc | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | ./module/resource_group | n/a |
| <a name="module_ssm"></a> [ssm](#module\_ssm) | ./module/ssm | n/a |
| <a name="module_ssm_role"></a> [ssm\_role](#module\_ssm\_role) | ./module/ssm_role | n/a |
| <a name="module_teams_alert"></a> [teams\_alert](#module\_teams\_alert) | ./module/teams_alert | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | environment name | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | prefix | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | product name | `string` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | profile | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->