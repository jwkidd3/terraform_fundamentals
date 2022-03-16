# Exercise #6: Modules

Terraform is *ALL* about modules.  Every terraform working directory is really just a module that could be reused by others. This is one of the key capabilities of Terraform.

* we are going to modularize the code we've been working with during this workshop
* instead of constantly redeclaring everything, we are just going to reference the module that we've created and see if it works

### Creating a Module

1. Create a main.tf file in the main directory for the 6th exercise.  Inside the `main.tf` file you created, add:

 ```hcl
 provider "aws" {
     version = "~> 2.0"
 }

 module "s3_bucket_01" {
     source        = "./modules/s3_bucket/"
     region        = "us-east-2"
     student_alias = var.student_alias
}

 # We're not defining region in this module call, so it will use the default as defined in the module
 # What happens when you remove the default from the module and don't pass here? Feel free to try it out.
 module "s3_bucket_02" {
     source        = "./modules/s3_bucket/"
     student_alias = var.student_alias
 }
 ```

1. Create a `variables.tf` file so we can capture `student_alias` and pass it through to our module:

 ```hcl
 variable "student_alias" {
     description = "Your student alias"
 }
 ```

 What we've done here is create a `main.tf` config file that references a module stored in a local directory, twice.  This allows us to encapsulate any complexity contained by the module's code while still allowing us to pass variables into the module.

1. Run init and apply.

 * notice that terraform manages each resource as if there is no module division
 * that is, the resources are bucketed into one big change list, but under the hood Terraform's dependency graph will show some separation
 * it's difficult, for example, to create dependencies between two resources that are in different modules
 * you can, however, use interpolation to create a variable dependency between two modules at the root level, ensuring one is created before the other
<br/><br/>
 Specific applications where direct resource dependency is required necessitate grouping those resources
 into a single module or project.
 <br/><br/>
1. Don't forget to destroy!
