# variables.tf

# Declare a variable so we can use it.
variable "student_alias" {
  description = "Your student alias"
  default     = "user30"
}
variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "example-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}