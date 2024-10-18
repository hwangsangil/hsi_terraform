resource "aws_cloudwatch_metric_alarm" "rds_alarm" {
  alarm_name          = "${local.prefix}-${local.product}-${local.env}-rds-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "RDS CPU 경고!! / RDS CPU Warning"
  alarm_actions       = [aws_sns_topic.teams_sns.arn]
}

#memroy alarm 사용 안함
# resource "aws_cloudwatch_metric_alarm" "rds_memory_alarm" {
#   alarm_name          = "${local.prefix}-${local.product}-${local.env}-rds-memory-alarm"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = 1
#   metric_name         = "FreeableMemory"
#   namespace           = "AWS/RDS"
#   period              = 300
#   statistic           = "Average"
#   threshold           = 2000000000
#   alarm_description   = "RDS 메모리 경고 / RDS Memory Warning Alarm"
#   alarm_actions       = [aws_sns_topic.teams_sns.arn]
# }

resource "aws_cloudwatch_metric_alarm" "rds_storage_alarm" {
  alarm_name          = "${local.prefix}-${local.product}-${local.env}-rds-storage-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 5000000000
  alarm_description   = "RDS 용량 경고 / RDS Storage Warning Alarm"
  alarm_actions       = [aws_sns_topic.teams_sns.arn]
}