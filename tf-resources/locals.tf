locals {
    prefix = "trash-day-scheduler"
    function_codedir_local_path             = "${path.module}/src"
    function_package_local_path              = "${local.function_dir_local_path}/dist/index.zip"
    function_package_base64sha256_local_path = "${local.function_package_local_path}.base64sha256"
    function_package_s3_key                  = "index.zip"
    function_package_base64sha256_s3_key     = "${local.function_package_s3_key}.base64sha256.txt"
}