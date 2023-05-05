

provider "aws"{
  region="us-west-1"
  alias="west"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  count = 2
  tags = {
    Name = "InstanceOne",
    class= "terraform"
  }
  lifecycle {
    create_before_destroy = true
  }
}
