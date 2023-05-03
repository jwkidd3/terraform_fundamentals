terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# declare a resource stanza so we can create something.
resource "aws_s3_bucket" "user_student_bucket" {
  bucket = "dws-di-${var.student_alias}"
}
