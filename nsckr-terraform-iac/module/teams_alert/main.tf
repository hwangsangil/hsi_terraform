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

resource "aws_iam_role" "lambda_role" {
  name = "${local.prefix}-${local.product}-${local.env}-teams-alert-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name = "${local.prefix}-${local.product}-${local.env}-teams-alert-lambda-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "logs:CreateLogGroup",
        "Resource" : "arn:aws:logs:ap-northeast-2:${data.aws_caller_identity.current.account_id}:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:ap-northeast-2:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${local.prefix}-${local.product}-${local.env}-teams-alert-lambda:*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "lambda:InvokeFunction",
        "Resource" : "arn:aws:lambda:ap-northeast-2:${data.aws_caller_identity.current.account_id}:function:${local.prefix}-${local.product}-${local.env}-teams-alert-lambda",
        "Condition" : {
          "ArnLike" : {
            "AWS:SourceArn" : "arn:aws:events:ap-northeast-2:${data.aws_caller_identity.current.account_id}:rule/*"
          }
        },
        "Sid" : "InvokeLambdaFunction"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_iam_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_iam_attachment_ec2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_lambda_function" "teams_lambda" {
  function_name = "${local.prefix}-${local.product}-${local.env}-teams-alert-lambda"
  filename      = "module/teams_alert/src/lambda.zip"
  handler       = "lambda_code.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  timeout       = "60"

  source_code_hash = filebase64sha256("module/teams_alert/src/lambda.zip")
  runtime          = "python3.9"

  environment {
    variables = {
      webhook_url = "{url}"
    }
  }
  lifecycle {
    ignore_changes = [environment]
  }
}

resource "aws_lambda_permission" "temas_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.teams_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.teams_sns.arn
}


resource "aws_lambda_permission" "temas_from_eventbridge_ecs" {
  statement_id  = "AllowExecutionFromEcsEventbridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.teams_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ecs_deployment_event.arn
}
resource "aws_lambda_permission" "temas_from_eventbridge_ec2" {
  statement_id  = "AllowExecutionFromEc2Eventbridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.teams_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_patch_event.arn
}