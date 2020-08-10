provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region  = "ap-northeast-1"
  version = "~> 3.00"
}

terraform {
  required_version = ">= 0.12"
}


variable "aws_access_key" {}
variable "aws_secret_key" {}
