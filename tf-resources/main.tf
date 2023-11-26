terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = ">= 3.0.0"
        }
        null = {
            source = "hashicorp/null"
            version = ">= 3.0.0"
        }
    }
    required_version = ">= 1.2.0"
}

provider aws {
    region = var.aws_region
    profile = var.aws_profile
}

locals {
    prefix = "trash-day-scheduler"
    functions_codedir_local_path                        = "${path.module}/src"
    helloworld_function_dir_local_path                  = "${local.functions_codedir_local_path}"
    helloworld_function_package_local_path              = "${local.helloworld_function_dir_local_path}/dist/index.zip"
    helloworld_function_package_base64sha256_local_path = "${local.helloworld_function_package_local_path}.base64sha256"
    helloworld_function_package_s3_key                  = "index.zip"
    helloworld_function_package_base64sha256_s3_key     = "${local.helloworld_function_package_s3_key}.base64sha256.txt"
}