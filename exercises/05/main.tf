
# declare a resource stanza so we can create something.
resource "aws_s3_bucket" "student_bucket_alt" {
  bucket  = "devint-${var.student_alias}-alt"
}

