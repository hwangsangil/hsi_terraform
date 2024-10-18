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
  url = "https://atc-github.azure.cloud.bmw/_services/token"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["0bbfab97059595e8d1ec48e89eb8657c0e5aae71", "d69b561148f01c77c54578c10926df5b856976ad", "FCB12F98AFE329464C2316A8BC0716BCF4BCC5B6"]
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
      variable = "atc-github.azure.cloud.bmw/_services/token:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "atc-github.azure.cloud.bmw/_services/token:sub"
      values   = ["repo:nsckrit/*:*"]
    }

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/atc-github.azure.cloud.bmw/_services/token"]
    }
  }
}