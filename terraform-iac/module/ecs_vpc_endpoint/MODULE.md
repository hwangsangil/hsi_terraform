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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_pri_ecs_vpce_sg"></a> [pri\_ecs\_vpce\_sg](#module\_pri\_ecs\_vpce\_sg) | terraform-aws-modules/security-group/aws | 5.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_endpoint.ecr_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_dkr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecs_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecs_telemetry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.secretsmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_subnets.pri-private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

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