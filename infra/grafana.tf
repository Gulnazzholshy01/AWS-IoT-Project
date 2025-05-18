resource "aws_grafana_workspace" "iot" {
  name                     = "IoT_Monitor"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"] 
  permission_type          = "SERVICE_MANAGED"
  data_sources             = ["TIMESTREAM"]
  role_arn                 = aws_iam_role.grafana_role.arn
}


resource "aws_iam_role" "grafana_role" {
  name = "grafana-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "grafana.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "grafana_timestream_readonly" {
  role       = aws_iam_role.grafana_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonTimestreamReadOnlyAccess"
}
