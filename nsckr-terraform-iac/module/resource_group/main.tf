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
}

resource "aws_resourcegroups_group" "patch_resource_group" {
  name        = "nsckr-patch-rg"
  description = "Resource group for patch targets"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance"
  ],
  "TagFilters": [
    {
      "Key": "patch",
      "Values": ["yes"]
    }
  ]
}
JSON
  }
}