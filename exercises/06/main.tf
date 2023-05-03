terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {}

module "s3_bucket_01" {
    source        = "./modules/s3_bucket/"
    region        = "us-east-2"
    student_alias = var.student_alias
}
module "s3_bucket_02" {
    source        = "./modules/s3_bucket/"
    student_alias = var.student_alias
}