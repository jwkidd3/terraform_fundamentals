

# declare a resource stanza so we can create something.
resource "aws_s3_bucket_object" "dynamic_file" {
  count   = "${var.object_count}"
  bucket  = "dws-di-${var.student_alias}"
  key     = "dynamic-file-${count.index}"
  content = "dynamic-file at index ${count.index}"
}

resource "aws_s3_bucket_object" "optional_file" {
  count   = "${var.include_optional_file ? 1 : 0}"
  bucket  = "dws-di-${var.student_alias}"
  key     = "optional-file"
  content = "optional-file"
}

