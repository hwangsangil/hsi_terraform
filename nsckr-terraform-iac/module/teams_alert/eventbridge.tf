resource "aws_cloudwatch_event_rule" "ecs_deployment_event" {
  name        = "${local.prefix}-${local.product}-${local.env}-ecs-deployment-failure-eventbridge"
  description = "ECS deployment failure detection"

  event_pattern = jsonencode({
    "source" : ["aws.ecs"],
    "detail-type" : ["ECS Deployment State Change"],
    "detail" : {
      "eventName" : ["SERVICE_DEPLOYMENT_FAILED"]
    }
  })
}

resource "aws_cloudwatch_event_target" "ecs_event_target" {
  rule      = aws_cloudwatch_event_rule.ecs_deployment_event.name
  target_id = "EcsSendToLambda"
  arn       = aws_lambda_function.teams_lambda.arn
}

resource "aws_cloudwatch_event_rule" "ec2_patch_event" {
  name        = "${local.prefix}-${local.product}-${local.env}-ec2-patch-eventbridge"
  description = "EC2 Patch Status is Not Compliant"

  event_pattern = jsonencode({
    "detail-type" : ["Configuration Compliance State Change"],
    "source" : ["aws.ssm"],
    "detail" : {
      "compliance-status" : ["non_compliant"]
    }
  })
}

resource "aws_cloudwatch_event_target" "ec2_event_target" {
  rule      = aws_cloudwatch_event_rule.ec2_patch_event.name
  target_id = "Ec2SendToLambda"
  arn       = aws_lambda_function.teams_lambda.arn
}