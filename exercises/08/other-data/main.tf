# main.tf

# A Terraform data source is a specific type of resource that gives us the ability to pull in data from elsewhere to
# use in our own terraform HCL and operations
data "aws_ami" "ubuntu" {
	most_recent = true

	filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
	}

	filter {
    name   = "virtualization-type"
    values = ["hvm"]
	}

	owners = ["099720109477"] # Canonical
}

# Another AWS provider data source, giving us the ability to get all of the AZs in our current region
data "aws_availability_zones" "available" {
  state = "available"
}

output "most_recent_ubuntu_ami_id" {
	value = "${data.aws_ami.ubuntu.id}"
}

output "current_region_availability_zones" {
  value = "${data.aws_availability_zones.available.names}"
}