terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region=var.region
}

# declare a resource stanza so we can create something.
resource "aws_s3_bucket" "user_bucket_random" {
  # bucket_prefix is a nice option in the aws provider for creating s3 buckets
  # the suffix will be a semi-random sequence
  bucket_prefix = "devint-${var.student_alias}-"
}
