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
resource "aws_instance" "test" {
  ami           = "ami-0889a44b331db0194"
  instance_type = "t2.micro"
  tags = {
    Name = "test"
  }
}
