output "iot_certificate_pem" {
  value     = aws_iot_certificate.my_cert.certificate_pem
  sensitive = true
}

output "iot_private_key" {
  value     = aws_iot_certificate.my_cert.private_key
  sensitive = true
}

output "iot_public_key" {
  value     = aws_iot_certificate.my_cert.public_key
  sensitive = true
}

output "root_ca_1_pem" {
  value     = data.http.root_ca_1.response_body
  sensitive = true
}

output "iot_endpoint" {
  value = data.aws_iot_endpoint.iot.endpoint_address
}

resource "local_file" "device_cert" {
  content  = aws_iot_certificate.my_cert.certificate_pem
  filename = "${path.module}/certs/device-cert.pem"
}

resource "local_file" "device_private_key" {
  content  = aws_iot_certificate.my_cert.private_key
  filename = "${path.module}/certs/device-private.key"
}

resource "local_file" "device_public_key" {
  content  = aws_iot_certificate.my_cert.public_key
  filename = "${path.module}/certs/device-public.key"
}

resource "local_file" "root_ca_1_file" {
  content  = data.http.root_ca_1.response_body
  filename = "${path.module}/certs/AmazonRootCA1.pem"
}
