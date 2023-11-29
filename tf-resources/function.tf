resource "aws_lambda_function" "lambda_function" {
    function_name = "${local.prefix}-lambda-function"
    timeout = 600
    memory_size = 512
    s3_bucket = aws_s3_bucket.lambda_package_bucket.bucket
    s3_key = data.aws_s3_object.lambda_package.key
    source_code_hash = data.aws_s3_object.lambda_package_hash.body
    handler = "index.handler"
    runtime = "nodejs20.x"
    publish = true
    role = aws_iam_role.lambda_role.arn
    environment {
        variables = {
            REGION = var.aws_region
            SSM_PARAMETER_NAME = var.ssm_parameter_name
            S3_BUCKET_NAME = var.google_calendar_api_bucket_name
            S3_OBJECT_KEY = var.google_calendar_api_file_name
            CALENDAR_ID = var.google_calendar_id
        }
    }
}

# ------------------------------
# パッケージデプロイ用のS3バケットを作成
# ------------------------------
resource "aws_s3_bucket" "lambda_package_bucket" {}

resource "aws_s3_bucket_server_side_encryption_configuration" "lambda_package_bucket" {
    bucket = aws_s3_bucket.lambda_package_bucket.bucket
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
            }
    }
}

resource "aws_s3_bucket_public_access_block" "lambda_package_bucket" {
    bucket = aws_s3_bucket.lambda_package_bucket.bucket
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

data "aws_s3_object" "lambda_package" {
    depends_on = [null_resource.npm_build]
    bucket = aws_s3_bucket.lambda_package_bucket.bucket
    key = local.function_package_s3_key
}

data "aws_s3_object" "lambda_package_hash" {
    bucket = aws_s3_bucket.lambda_package_bucket.bucket
    depends_on = [null_resource.npm_build]
    key = local.function_package_base64sha256_s3_key
}

# ------------------------------
# 権限設定
# ------------------------------

resource "aws_lambda_permission" "lambda_permission" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda_function.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_scheduler_schedule.eventbridge.arn
}

resource "aws_iam_role" "lambda_role" {
    name = "${local.prefix}-lambda-role"
    assume_role_policy = file("${path.module}/policies/lambda-role.json")
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
    role = aws_iam_role.lambda_role.id
    policy_arn = data.aws_iam_policy.lambda_basic_execution.arn
}

data "aws_iam_policy" "lambda_basic_execution" {
    arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_ssm_parameter" {
    role = aws_iam_role.lambda_role.id
    policy_arn = aws_iam_policy.lambda_custom_policy.arn
}

resource "aws_iam_policy" "lambda_custom_policy" {
    policy = templatefile("${path.module}/policies/lambda-policy.json", {
        region = var.aws_region
        account_id = var.aws_account_id
        parameter_name = var.ssm_parameter_name
        bucket_name = var.google_calendar_api_bucket_name
    })
}

# ------------------------------
# ロググループを作成
# ------------------------------
resource "aws_cloudwatch_log_group" "lambda_log_group" {
    name = "/aws/lambda/${local.prefix}-lambda-fucntion"
}


# ------------------------------
# コマンドの実行
# ------------------------------
resource "null_resource" "npm_build" {
    depends_on = [aws_s3_bucket.lambda_package_bucket]


    triggers = {
        code_diff = join("", [
        for file in fileset(local.function_codedir_local_path, "{*.ts, package*.json}")
        : filebase64("${local.function_codedir_local_path}/${file}")
        ])
    }

    provisioner "local-exec" {
        command = "cd ${path.module}/src && npm install"
    }
    provisioner "local-exec" {
        command = "cd ${path.module}/src && npm run build"
    }
    provisioner "local-exec" {
        command = "aws s3 cp ${local.function_package_local_path} s3://${aws_s3_bucket.lambda_package_bucket.bucket}/${local.function_package_s3_key}"
    }
    provisioner "local-exec" {
        command = "openssl dgst -sha256 -binary ${local.function_package_local_path} | openssl enc -base64 | tr -d \"\n\" > ${local.function_package_base64sha256_local_path}"
    }
    provisioner "local-exec" {
        command = "aws s3 cp ${local.function_package_base64sha256_local_path} s3://${aws_s3_bucket.lambda_package_bucket.bucket}/${local.function_package_base64sha256_s3_key} --content-type \"text/plain\""
    }
}
