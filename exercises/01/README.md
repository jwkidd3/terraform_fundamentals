# Exercise #1: Your First Terraform Project

Look at this directory and you'll see a couple of `.tf` files.

```bash
ls -lah
```

### main.tf

Generally the name of the major configuration file in a Terraform working directory (but name is arbitrary).

```HCL
# Declare the provider being used, in this case it's AWS.
# This provider supports setting the provider version, AWS credentials as well as the region.
# It can also pull credentials and the region to use from environment variables, which we have set, so we'll use those
provider "aws" {
  version = "~> 2.0"
}

# declare a resource stanza so we can create something, in this case a key pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "devint-${var.student_alias}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCziJcgg6vF7WkuRhCso3XnQX8oZ/NXW2a+g3PJrVshJJb9rLsYk4oXEaUu3D2IcVRRcxffiG+I5sJvN7BtomxCZ5lr77xBpB0zs4QnnmtB9sFSHXre4GRQbMDxImyqgmcVcSDKH+bFfe1/km08UjDz/kUNtrFWVJiJAmFndbEK5b/j0OOChtQKUlT3+XkLhrD7ek7s1hpxuSoAYMCux7t/VeUy2y/SuLK86EaGM+yWSh5C4gKQ9DU2uC8zKDpZoXtDAXgkhiF7Ub/X0S3c1OAXD7RwPkFErz5quWi34uSYBIFzGxuX4EwzJ++fiDwKMtnnhlpHPhlfhGnYy+Gn/OkZxltwfkWeJv8jCv4lnjm6riFBHPpZJHwTtxs3jYxgLAPLy4Ijlt60o60KC71PzGddmOr3BxfVKKmp2YtA40l2iQZA65LpoPiCOpQfEw1BW7lhT8MNLA4SeBhL2nqb4CFYX5C6xUsc4kgvNBzJ/WGMxmUFAHjdEL/2ziXuOJSwkxdfbDnlJ7KshzEi912gpVO8lTrXnGOXdupS6WeGtuJzVh0YPAU8IMXm7CzqUSrfZ2KpFq3eth7Euba0zunEiGY0oF66
kT3Kq4SI9cPF3rpg8rBz4DciitgWdz5+F9cG2xXhpFNoXZExP0oTYASkgg4GQVC+QibN1ERIMyAJxbiklQ
=="
}
```

### variables.tf

```hcl
# Declare a variable so we can use it
variable "student_alias" {
  description = "Your student alias"
}
```

This directory is a  simple example of a terraform project or module.

### Commands

Let's run some terraform commands!

`terraform init`
* generally the first command you run after writing your config files
* initializes the working directory to prepare terraform to run plans and applies

`terraform fmt`
* simple syntax corrector that analyzes HCL in a given directory (including sub-directories) and corrects small syntactical issues

`terraform validate`
* runs a deeper scan of config to show potential issues with more complex problems such as circular dependencies and missing values
* v0.12 made validate a bit simpler as far as what it does

If "terraform init" successful, you're ready to move on. For now, don't run apply. We'll get to this in a future exercise.
