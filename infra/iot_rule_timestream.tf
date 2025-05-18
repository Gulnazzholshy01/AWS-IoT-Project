resource "aws_iot_topic_rule" "iot_to_timestream" {
  name        = "iot_to_timestream"
  description = "Rule to insert IoT messages into Timestream"
  enabled     = true
  sql         = "SELECT temperature, humidity FROM 'esp32/pub'"
  sql_version = "2016-03-23"

  timestream {
    database_name = aws_timestreamwrite_database.iot_db.database_name
    table_name    = aws_timestreamwrite_table.iot_table.table_name
    role_arn      = aws_iam_role.iot_rule_role.arn

    dimension {
      name  = "device_id"
      value = "device_1"
    }
  }

  error_action {
    cloudwatch_logs {
      log_group_name = aws_cloudwatch_log_group.iot_errors.name
      role_arn       = aws_iam_role.iot_rule_error_role.arn
    }
  }

}

# CloudWatch Log Group for error logs
resource "aws_cloudwatch_log_group" "iot_errors" {
  name              = "iot_to_timestream_errors"
  retention_in_days = 7
}


### IoT Assume Role Policy
data "aws_iam_policy_document" "iot_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["iot.amazonaws.com"]
    }
    effect = "Allow"
  }
}


### IoT policy to write to timestream
data "aws_iam_policy_document" "iot_write_to_timestream" {
  statement {
    actions = [
      "timestream:WriteRecords",
      "timestream:DescribeEndpoints"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

# IAM Role for IoT Rule to Timestream
resource "aws_iam_role" "iot_rule_role" {
  name               = "iot_to_timestream_role"
  assume_role_policy = data.aws_iam_policy_document.iot_assume_role_policy.json
}

resource "aws_iam_role_policy" "iot_rule_policy" {
  name   = "iot_to_timestream_policy"
  role   = aws_iam_role.iot_rule_role.id
  policy = data.aws_iam_policy_document.iot_write_to_timestream.json
}


# IAM Role for IoT Rule Error Action
resource "aws_iam_role" "iot_rule_error_role" {
  name               = "iot_rule_error_role"
  assume_role_policy = data.aws_iam_policy_document.iot_assume_role_policy.json
}

# Permissions Policy (Allow writing to CloudWatch Logs)
data "aws_iam_policy_document" "iot_error_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["${aws_cloudwatch_log_group.iot_errors.arn}:*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role_policy" "iot_rule_error_policy" {
  role   = aws_iam_role.iot_rule_error_role.id
  policy = data.aws_iam_policy_document.iot_error_policy.json
}
