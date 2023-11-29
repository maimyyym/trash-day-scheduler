// テスト記述
resource "aws_ssm_parameter" "google_calendar_api_key" {
  name           = "${var.ssm_parameter_name}"
  type           = "String"
  insecure_value = var.google_calendar_api_key
  tags = {
    environment = var.environment
  }
}