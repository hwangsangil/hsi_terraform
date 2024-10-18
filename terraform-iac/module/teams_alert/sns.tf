resource "aws_sns_topic" "teams_sns" {
  name              = "${local.prefix}-${local.product}-${local.env}-sns-topic"
  kms_master_key_id = aws_kms_alias.sns_cmk.name

  sqs_success_feedback_sample_rate = "100"
  sqs_success_feedback_role_arn    = aws_iam_role.sns_role.arn
  sqs_failure_feedback_role_arn    = aws_iam_role.sns_role.arn
}

resource "aws_sns_topic_policy" "sns_policy" {
  arn = aws_sns_topic.teams_sns.arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    sid    = "SNS Topic Access policy"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [data.aws_caller_identity.current.account_id]
    }
    resources = [aws_sns_topic.teams_sns.arn]
  }
  statement {
    sid    = "Allow_Publish_Alarms"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
      # service= "cloudwatch.amazonaws.com"
    }
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.teams_sns.arn]
  }
}

resource "aws_sns_topic_subscription" "teams_sns_subscription" {
  topic_arn = aws_sns_topic.teams_sns.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.teams_lambda.arn
}

resource "aws_iam_role" "sns_role" {
  name = "${local.prefix}-${local.product}-${local.env}-sns-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "sns.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sns_attach_policy" {
  role       = aws_iam_role.sns_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSNSRole"
}