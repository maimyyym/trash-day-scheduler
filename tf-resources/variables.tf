variable "aws_region" {
    description = "AWS Region"
    type        = string
}

variable "aws_account_id" {
    description = "AWS Account ID"
    type        = string
}
variable "aws_profile" {
    description = "AWS Profile"
    type        = string
}

variable "environment" {
    description = "Environment"
    type        = string
}

variable "ssm_parameter_name" {
    description = "SSM Parameter Name"
    type        = string
}

variable "google_calendar_api_path" {
    description = "Google Calendar API Path"
    type        = string
}

variable "google_calendar_api_file_name" {
    description = "Google Calendar API File Name"
    type        = string
}

variable "google_calendar_api_bucket_name" {
    description = "Google Calendar API Bucket Name"
    type        = string
}

variable "google_calendar_api_key" {
    description = "Google Calendar API Key"
    type        = string
}

variable "google_calendar_id" {
    description = "Calendar ID"
    type        = string
}