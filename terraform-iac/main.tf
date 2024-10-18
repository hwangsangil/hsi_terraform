terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
  backend "s3" {
    bucket         = "terraform-tfbackend"
    region         = "ap-northeast-2"
    encrypt        = "true"
    dynamodb_table = "tfbackend-dynamodb"
  }
}

module "ecs_vpc_endpoint" {
  source = "./module/ecs_vpc_endpoint"

  profile = var.profile
  prefix  = var.prefix
  product = var.product
  env     = var.env
}

module "elb" {
  source = "./module/elb"

  profile = var.profile
  prefix  = var.prefix
  product = var.product
  env     = var.env
}

module "oidc" {
  source = "./module/oidc"

  profile = var.profile
  prefix  = var.prefix
  product = var.product
  env     = var.env
}

module "ssm" {
  source = "./module/ssm"

  profile = var.profile
  prefix  = var.prefix
  product = var.product
  env     = var.env
}

module "ssm_role" {
  source = "./module/ssm_role"

  profile = var.profile
  prefix  = var.prefix
  product = var.product
  env     = var.env
}

module "resource_group" {
  source = "./module/resource_group"

  profile = var.profile
}

module "teams_alert" {
  source = "./module/teams_alert"

  profile = var.profile
  prefix  = var.prefix
  product = var.product
  env     = var.env
}

module "ecr" {
  source = "./module/ecr"

  profile = var.profile
  prefix  = var.prefix
  product = var.product
  env     = var.env
}