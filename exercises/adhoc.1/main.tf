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
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"
  name    = var.vpc_name
  cidr    = var.vpc_cidr
}
