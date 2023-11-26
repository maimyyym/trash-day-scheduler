output "lambda_functions" {
  description = "value of lambda_functions"
  value = aws_lambda_function.lambda_function
}

output "eventbridge" {
  description = "value of eventbridge"
  value = aws_scheduler_schedule.eventbridge
}