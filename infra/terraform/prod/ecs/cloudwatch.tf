resource "aws_cloudwatch_log_group" "main" {
  name              = "${var.project}-log-terraform"
  retention_in_days = 90
}