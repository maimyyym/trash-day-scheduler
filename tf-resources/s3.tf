resource "aws_s3_bucket" "google_api" {
    bucket = "${var.google_calendar_api_bucket_name}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "google_api" {
    bucket = aws_s3_bucket.google_api.bucket
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
            }
    }
}

resource "aws_s3_bucket_public_access_block" "google_api" {
    bucket = aws_s3_bucket.google_api.bucket
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

# ------------------------------
# コマンド実行
# ------------------------------
resource "null_resource" "json_copy" {
    provisioner "local-exec" {
        command = "aws s3 cp ${var.google_calendar_api_path} s3://${aws_s3_bucket.google_api.bucket}/${var.google_calendar_api_file_name}"
    }
}