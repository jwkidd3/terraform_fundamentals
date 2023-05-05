

# declare a resource stanza so we can create something.
resource "aws_s3_object" "user_student_alias_object" {
  bucket  = "dws-di-${var.student_alias}"
  key     = "student.alias"
  content = "************"
}
output "myout"{
  value=aws_s3_object.user_student_alias_object.content_type
}