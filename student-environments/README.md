# How to create student accounts

The intention is that the instructor will create limited IAM accounts for the students in the course.

The __`terraform.sh`__ script can be used with the argument __`apply`__ or __`destroy`__ to create or destroy the student accounts.
(And of course __`plan`__ can be used to see what will be created.) You will need to create a PGP key as it is exported by the script
and consumed by Terraform.

Before running that script, you should put the desired login names for the students into the file __`names.txt`__.

Ultimately, those names need to make it into __`terraform.tfvars`__. You can hand edit the __`terraform.tfvars`__ file, but there
is a Python script called changer.py which generates a new __`terraform.tfvars`__ with the new names from __`names.txt`__ (instructions
are at the top of the script).
