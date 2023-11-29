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