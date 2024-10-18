# VPCE 시큐리티 그룹 생성

module "pri_ecs_vpce_sg" {
  source          = "terraform-aws-modules/security-group/aws"
  version         = "5.1.0"
  name            = var.env == "dev" || var.env == "prod" ? "${local.prefix}-${local.product}-${local.env}-ecs-vpce-sg" : "${local.prefix}-${local.product}-ecs-vpce-sg"
  use_name_prefix = "false"
  description     = "Pirvate ECS-VPCE Security Group"
  vpc_id          = data.aws_vpc.private.id


  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "from ecs"
      cidr_blocks = data.aws_vpc.private.cidr_block_associations[0].cidr_block
      # cidr_blocks = "10.10.0.0/16"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "from ecs"
      cidr_blocks = data.aws_vpc.private.cidr_block_associations[1].cidr_block
      # cidr_blocks = "10.10.0.0/16"
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
  # egress_rules        = ["all-all"]

  tags = {
    Name = var.env == "dev" || var.env == "prod" ? "${local.prefix}-${local.product}-${local.env}-ecs-vpce-sg" : "${local.prefix}-${local.product}-ecs-vpce-sg"
  }

  # ingress_cidr_blocks = ["10.10.0.0/16"]
  # ingress_rules       = ["https-443-tcp"]
  # egress_rules        = ["all-all"]
}