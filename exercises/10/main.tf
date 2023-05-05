

# The part that ensures that the state for this infrastructure will be centrally stored, in S3
terraform {
  backend "s3" {}
}

# declare a resource stanza so we can create something.
resource "aws_s3_bucket_object" "user_student_alias_object" {
  bucket  = "devint-${var.student_alias}"
  key     = "student.alias"
  content = "This bucket is reserved for ${var.student_alias}"
}
