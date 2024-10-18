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


resource "aws_iam_role" "SSM_ROLE" {
  name        = "${local.prefix}-${local.product}-${local.env}-ssm-role"
  path        = "/"
  description = "EC2 basic role attach (Access EC2 using SSM, access S3 Bucket and read cloudwatch logs)"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  # tags = {
  #   tag-key = "tag-value"
  # }
}

resource "aws_iam_instance_profile" "SSM_PROFILE" {
  name = "${local.prefix}-${local.product}-${local.env}-ssm-role"
  role = aws_iam_role.SSM_ROLE.name
}

resource "aws_iam_policy" "S3_POLICY" {
  name        = "${local.prefix}-${local.product}-${local.env}-s3-policy"
  path        = "/"
  description = "reduced policy for s3 access"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*",
          "s3-object-lambda:*"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Deny",
        "Action" : [
          "s3:DeleteBucketPolicy",
          "s3:PutBucketAcl",
          "s3:PutBucketPolicy",
          "s3:PutEncryptionConfiguration",
          "s3:PutObjectAcl",
          "s3:PutAccountPublicAccessBlock",
          "s3:DeleteBucket",
          "s3:PutBucketOwnershipControls"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_policy" {
  role       = aws_iam_role.SSM_ROLE.name
  count      = length(var.iam_policy_list)
  policy_arn = var.iam_policy_list[count.index]
}

resource "aws_iam_role_policy_attachment" "s3_policy" {
  role       = aws_iam_role.SSM_ROLE.name
  policy_arn = aws_iam_policy.S3_POLICY.arn
}
