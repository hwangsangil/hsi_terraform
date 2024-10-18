terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-northeast-2"
  profile = local.profile
}

locals {
  profile = var.profile
  prefix  = var.prefix
  product = var.product
  env     = var.env
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = data.aws_vpc.private.id
  service_name        = "com.amazonaws.ap-northeast-2.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [module.pri_ecs_vpce_sg.security_group_id]

  subnet_ids = data.aws_subnets.pri-private.ids

  tags = {
    Name = var.env == "dev" || var.env == "prod" ? "${local.prefix}-${local.product}-${local.env}-ecr_dkr-vpce" : "${local.prefix}-${local.product}-ecr_dkr-vpce"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = data.aws_vpc.private.id
  service_name        = "com.amazonaws.ap-northeast-2.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [module.pri_ecs_vpce_sg.security_group_id]

  subnet_ids = data.aws_subnets.pri-private.ids

  tags = {
    Name = var.env == "dev" || var.env == "prod" ? "${local.prefix}-${local.product}-${local.env}-ecr_api-vpce" : "${local.prefix}-${local.product}-ecr_api-vpce"
  }
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = data.aws_vpc.private.id
  service_name        = "com.amazonaws.ap-northeast-2.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [module.pri_ecs_vpce_sg.security_group_id]

  subnet_ids = data.aws_subnets.pri-private.ids

  tags = {
    Name = var.env == "dev" || var.env == "prod" ? "${local.prefix}-${local.product}-${local.env}-secretsmanager-vpce" : "${local.prefix}-${local.product}-secretsmanager-vpce"
  }
}

resource "aws_vpc_endpoint" "ecs_agent" {
  vpc_id              = data.aws_vpc.private.id
  service_name        = "com.amazonaws.ap-northeast-2.ecs-agent"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [module.pri_ecs_vpce_sg.security_group_id]

  subnet_ids = data.aws_subnets.pri-private.ids


  tags = {
    Name = var.env == "dev" || var.env == "prod" ? "${local.prefix}-${local.product}-${local.env}-ecs_agent-vpce" : "${local.prefix}-${local.product}-ecs_agent-vpce"
  }
}

resource "aws_vpc_endpoint" "ecs" {
  vpc_id              = data.aws_vpc.private.id
  service_name        = "com.amazonaws.ap-northeast-2.ecs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [module.pri_ecs_vpce_sg.security_group_id]

  subnet_ids = data.aws_subnets.pri-private.ids

  tags = {
    Name = var.env == "dev" || var.env == "prod" ? "${local.prefix}-${local.product}-${local.env}-ecs-vpce" : "${local.prefix}-${local.product}-ecs-vpce"
  }
}

resource "aws_vpc_endpoint" "ecs_telemetry" {
  vpc_id              = data.aws_vpc.private.id
  service_name        = "com.amazonaws.ap-northeast-2.ecs-telemetry"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [module.pri_ecs_vpce_sg.security_group_id]

  subnet_ids = data.aws_subnets.pri-private.ids

  tags = {
    Name = var.env == "dev" || var.env == "prod" ? "${local.prefix}-${local.product}-${local.env}-ecs_telemetry-vpce" : "${local.prefix}-${local.product}-ecs_telemetry-vpce"
  }
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id              = data.aws_vpc.private.id
  service_name        = "com.amazonaws.ap-northeast-2.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [module.pri_ecs_vpce_sg.security_group_id]

  subnet_ids = data.aws_subnets.pri-private.ids

  tags = {
    Name = var.env == "dev" || var.env == "prod" ? "${local.prefix}-${local.product}-${local.env}-logs-vpce" : "${local.prefix}-${local.product}-logs-vpce"
  }
}

resource "aws_vpc_endpoint" "rds" {
  vpc_id              = data.aws_vpc.private.id
  service_name        = "com.amazonaws.ap-northeast-2.rds"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [module.pri_ecs_vpce_sg.security_group_id]

  subnet_ids = data.aws_subnets.pri-private.ids

  tags = {
    Name = var.env == "dev" || var.env == "prod" ? "${local.prefix}-${local.product}-${local.env}-rds-vpce" : "${local.prefix}-${local.product}-rds-vpce"
  }
}