# VPCE 시큐리티 그룹 생성

module "pri_ssm_vpce_sg" {
  source          = "terraform-aws-modules/security-group/aws"
  version         = "5.1.0"
  name            = var.env == "dev" || var.env == "prod" ? "${local.prefix}-${local.product}-${local.env}-ssm-vpce-sg" : "${local.prefix}-${local.product}-ssm-vpce-sg"
  use_name_prefix = "false"
  description     = "Private SSM-VPCE Security Group"
  vpc_id          = data.aws_vpc.private.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "from ssm-user"
      cidr_blocks = data.aws_vpc.private.cidr_block_associations[0].cidr_block
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "from ssm-user"
      cidr_blocks = data.aws_vpc.private.cidr_block_associations[1].cidr_block
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name = var.env == "dev" || var.env == "prod" ? "${local.prefix}-${local.product}-${local.env}-ssm-vpce-sg" : "${local.prefix}-${local.product}-ssm-vpce-sg"
  }
}