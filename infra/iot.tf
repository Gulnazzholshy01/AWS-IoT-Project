# Create a thing
resource "aws_iot_thing" "my_thing" {
  name = var.thing
}

# Create a certificate
resource "aws_iot_certificate" "my_cert" {
  active = true
}

# Create a policy
resource "aws_iot_policy" "thing_policy" {
  name   = var.thing_policy
  policy = data.aws_iam_policy_document.aws_iot_thing_policy.json
}

# Attach cert to policy
resource "aws_iot_policy_attachment" "policy_attach" {
  policy = aws_iot_policy.thing_policy.name
  target = aws_iot_certificate.my_cert.arn
}

# Attach cert to thing
resource "aws_iot_thing_principal_attachment" "thing_attach" {
  thing     = aws_iot_thing.my_thing.name
  principal = aws_iot_certificate.my_cert.arn
}






