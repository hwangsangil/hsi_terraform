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

resource "aws_vpc_endpoint" "ssm_ec2messages" {
  vpc_id            = data.aws_vpc.private.id
  service_name      = "com.amazonaws.ap-northeast-2.ec2messages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [module.pri_ssm_vpce_sg.security_group_id]

  subnet_ids          = data.aws_subnets.pri-private.ids
  private_dns_enabled = true


  tags = {
    Name = var.env == "dev" || var.env == "prod" ? "${local.prefix}-${local.product}-${local.env}-ssm-vpce" : "${local.prefix}-${local.product}-ssm-vpce"
  }
}

resource "aws_vpc_endpoint" "ssm_ssmmessages" {
  vpc_id            = data.aws_vpc.private.id
  service_name      = "com.amazonaws.ap-northeast-2.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [module.pri_ssm_vpce_sg.security_group_id]

  subnet_ids          = data.aws_subnets.pri-private.ids
  private_dns_enabled = true

  tags = {
    Name = var.env == "dev" || var.env == "prod" ? "${local.prefix}-${local.product}-${local.env}-ssm-vpce" : "${local.prefix}-${local.product}-ssm-vpce"
  }
}

resource "aws_vpc_endpoint" "ssm_ssm" {
  vpc_id            = data.aws_vpc.private.id
  service_name      = "com.amazonaws.ap-northeast-2.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids = [module.pri_ssm_vpce_sg.security_group_id]

  subnet_ids          = data.aws_subnets.pri-private.ids
  private_dns_enabled = true

  tags = {
    Name = var.env == "dev" || var.env == "prod" ? "${local.prefix}-${local.product}-${local.env}-ssm-vpce" : "${local.prefix}-${local.product}-ssm-vpce"
  }
}