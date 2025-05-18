resource "aws_iot_topic_rule" "iot_to_sns_temp_alert" {
  name        = "temperature_rule"
  description = "Send SMS if temperature > 30"
  enabled     = true
  sql         = "SELECT CONCAT('🚨 High Temperature Alert: ', CAST(temperature AS VARCHAR), '°C') AS alert_message FROM 'esp32/pub' WHERE temperature > 30"
  sql_version = "2016-03-23"


  sns {
    message_format = "RAW"
    role_arn       = aws_iam_role.iot_sns_role.arn
    target_arn     = aws_sns_topic.iot_alerts.arn
  }

  error_action {
    cloudwatch_logs {
      log_group_name = aws_cloudwatch_log_group.iot_errors.name
      role_arn       = aws_iam_role.iot_rule_error_role.arn
    }
  }

}

resource "aws_sns_topic" "iot_alerts" {
  name = "high_temperature_topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.iot_alerts.arn
  protocol  = "email"
  endpoint  = "gulnaz.zholshy@yahoo.com"
}


resource "aws_iam_role" "iot_sns_role" {
  name               = "iot_sns_role"
  assume_role_policy = data.aws_iam_policy_document.iot_assume_role_policy.json
}

data "aws_iam_policy_document" "sns_policy" {
  statement {
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.iot_alerts.arn]
  }
}

resource "aws_iam_role_policy" "mypolicy" {
  name   = "sns_publish_policy"
  role   = aws_iam_role.iot_sns_role.id
  policy = data.aws_iam_policy_document.sns_policy.json
}