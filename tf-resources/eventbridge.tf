resource "aws_scheduler_schedule" "eventbridge" {
    name = "${local.prefix}-eventbridge"
    group_name = "default" 
    flexible_time_window  {
        mode = "OFF"
    }
    # 毎日0時に実行
    schedule_expression = "cron(0 0 * * ? *)"
    schedule_expression_timezone = "Asia/Tokyo"
    target  {
        arn = aws_lambda_function.lambda_function.arn
        role_arn = aws_iam_role.eventbridge_scheduler.arn
    }
}

################################################################################
# IAM Role for EventBridge Scheduler                                           #
################################################################################
resource "aws_iam_role" "eventbridge_scheduler" {
    name               = "iam_role_name_eventbridge_scheduler"
    assume_role_policy = data.aws_iam_policy_document.eventbridge_scheduler_assume.json
}

data "aws_iam_policy_document" "eventbridge_scheduler_assume" {
    statement {
        effect = "Allow"

        actions = [
        "sts:AssumeRole",
        ]

        principals {
        type = "Service"
        identifiers = [
            "scheduler.amazonaws.com",
        ]
        }
    }
}

resource "aws_iam_role_policy" "eventbridge_scheduler_custom" {
    name   = "iam_policy_name_eventbridge_scheduler"
    role   = aws_iam_role.eventbridge_scheduler.name
    policy = data.aws_iam_policy_document.eventbridge_scheduler_custom.json
}

data "aws_iam_policy_document" "eventbridge_scheduler_custom" {
    statement {
        effect = "Allow"

        actions = [
        "lambda:InvokeFunction",
        ]

    resources = [
        "*",
        ]
    }
}
