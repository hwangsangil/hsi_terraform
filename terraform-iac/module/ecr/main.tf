terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
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

resource "aws_ecr_repository" "ecr_repository" {
  name                 = "${local.prefix}-${local.product}-${local.env}-ecr"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "ecr_repository_policy" {
  repository = aws_ecr_repository.ecr_repository.name

  lifecycle {
    ignore_changes = [policy]
  }


  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "remove outdated image",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 3
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}


resource "null_resource" "pwd_and_whoami" {
  provisioner "local-exec" {
    command = "pwd"
  }
  provisioner "local-exec" {
    command = "whoami"
  }
}

resource "null_resource" "aws_caller_identity" {
  provisioner "local-exec" {
    command = "aws sts get-caller-identity"
  }
}

resource "null_resource" "ecr_upload_initial_image" {
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-2.amazonaws.com"
  }
  provisioner "local-exec" {
    command = "docker pull nginx:latest"
    #    working_dir = "${path.module}/nginx"
  }
  provisioner "local-exec" {
    command = "docker tag nginx:latest ${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-2.amazonaws.com/${aws_ecr_repository.ecr_repository.name}:nginx-test"
  }
  provisioner "local-exec" {
    command = "docker push ${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-2.amazonaws.com/${aws_ecr_repository.ecr_repository.name}:nginx-test"
  }
}

output "aws_caller_identity" {
  value = null_resource.aws_caller_identity

}