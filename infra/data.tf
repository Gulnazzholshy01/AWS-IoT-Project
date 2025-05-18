data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# output "account_id" {
#   value = data.aws_caller_identity.current.account_id
# }

data "aws_iot_endpoint" "iot" {
  endpoint_type = "iot:Data-ATS"
}

data "http" "root_ca_1" {
  url    = "https://www.amazontrust.com/repository/AmazonRootCA1.pem"
  method = "GET"
}

data "aws_iam_policy_document" "aws_iot_thing_policy" {
  version = "2012-10-17"
  statement {
    sid    = "ClientConnectRestrictred"
    effect = "Allow"
    actions = [
      "iot:Connect",
      "iot:Publish",
      "iot:Receive",
      "iot:Subscribe"
    ]
    resources = [
      "*"
    ]
  }
}