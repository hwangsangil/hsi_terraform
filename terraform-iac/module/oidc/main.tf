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

resource "aws_iam_openid_connect_provider" "atc-github" {
  url = ""

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [""]
}

resource "aws_iam_role" "aws-gh-oidc-role" {
  name = var.env == "dev" || var.env == "prod" ? "${local.prefix}-${local.product}-${local.env}-aws-github-role" : "${local.prefix}-${local.product}-aws-github-role"
  #   name = "${local.prefix}-${local.product}-${local.env}-aws-github-role"
  #   name = "aws-gh-oidc-role"

  assume_role_policy = data.aws_iam_policy_document.trustrelation.json

  tags = {
    DeployedBy = "terraform_iac"
  }
}

data "aws_iam_policy_document" "trustrelation" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = ""
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = ""
      values   = ["repo:it/*:*"]
    }

    principals {
      type        = "Federated"
      identifiers = [""]
    }
  }
}