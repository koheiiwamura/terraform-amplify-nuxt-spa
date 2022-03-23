resource "aws_secretsmanager_secret" "parameters" {
  name = "${var.service_name}${var.env_suffix}"
}
