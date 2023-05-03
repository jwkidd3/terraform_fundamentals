terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    
  }
}

provider "aws" {
  region="us-east-1"
}

# declare a resource stanza so we can create something.
resource "aws_s3_object" "user_student_alias_object" {
  bucket  = "dws-di-${var.student_alias}"
  key     = "student.alias"
  content = "************"
}
output "myout"{
  value=aws_s3_object.user_student_alias_object.content_type
}