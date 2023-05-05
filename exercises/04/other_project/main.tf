

# declare a resource stanza so we can create something.
resource "aws_s3_bucket" "user_bucket" {
  bucket_prefix = "${var.student_name}"
  versioning {
    enabled = true
  }
}

