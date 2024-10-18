data "aws_iam_policy_document" "cmk_policy" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/fpc/UserFull"]
    }
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow access for Key Administrators"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/fpc/UserFull"]
    }
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/fpc/UserFull"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/fpc/UserFull"]
    }
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"

      values = ["true"]

    }
  }

  statement {
    sid    = "Allow_CloudWatch_for_CMK"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
      # service= "cloudwatch.amazonaws.com"
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]
  }
}

resource "aws_kms_key" "sns_cmk" {
  description = "Use encrypted SNS"
  policy      = data.aws_iam_policy_document.cmk_policy.json
  lifecycle {
    ignore_changes = [policy]
  }
}

resource "aws_kms_alias" "sns_cmk" {
  name          = "alias/${local.product}-${local.env}-cmk"
  target_key_id = aws_kms_key.sns_cmk.key_id
}