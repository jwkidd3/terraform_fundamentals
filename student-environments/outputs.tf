output "students" {
  value = var.students
}

output "passwords" {
  value = [aws_iam_user_login_profile.students[*].encrypted_password]
}

output "test_access_keys" {
  value = [aws_iam_access_key.tests[*].id]
}

output "test_secret_keys" {
  value = [aws_iam_access_key.tests[*].secret]
}
